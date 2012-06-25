class User < CouchRest::Model::Base
  property :name,     String
  property :email,    String
  property :password, String
  property :bio,      String
  property :url,      String
  property :location, String
  property :lang,     String
  property :tz,       String
  property :protect,  TrueClass
  property :verified, TrueClass

  timestamps!

  validates_presence_of :password
  validates_length_of   :email,    in: 6..255
  validates_length_of   :name,     maximum: 255
  validates_length_of   :bio,      maximum: 160
  validates_length_of   :location, maximum: 255
  validates_length_of   :lang,     maximum: 8
  validates_length_of   :tz,       maximum: 8
  validates_length_of   :url,      maximum: 255

  design do
    view :by_lang,
      map: %q{
        function(doc) {
          if (doc.type == 'User' && doc.lang) {
            emit(doc.lang, null);
          }
        }
      },
      reduce: '_count'

    view :by_location,
      map: %q{
        function(doc) {
          if (doc.type == 'User' && doc.location) {
            emit(doc.location, null);
          }
        }
      },
      reduce: '_count'
  end

  # Authenticate a user with plain text password.
  #
  # password - A String of plain text password the user provided during
  #            authentication.
  #
  # Returns a Boolean true if the password matches the stored bcrypt hash.
  def authenticate(password)
    hash = BCrypt::Password.new(self.password) rescue nil
    hash && hash == password
  end

  # Override password= to bcrypt hash plain text passwords before they're
  # saved to the database.
  #
  # password - The String password to set. This may be a plain text password
  #            String from the user or a bcrypted String from the database.
  #            We handle both cases and don't bcrypt things twice.
  #
  # Returns nothing.
  def password=(password)
    # already bcrypted
    write_attribute(:password, BCrypt::Password.new(password))
  rescue
    # plain text
    write_attribute(:password, BCrypt::Password.create(password))
  end

  # Create and save a new Tweet. Update all followers' timelines.
  #
  # text   - The String text message to share with the world.
  # source - The String client source identifier from which the tweet was sent
  #          (e.g. 'web', 'Tweetbot', etc.)
  #
  # Examples
  #
  #   tweet = user.tweet('Hello!', 'web')
  #   # => #<Tweet user_id: "alice", source: "web", text: "Hello!", . . .>
  #
  #   tweet.id
  #   # => '04c2a13b634190035ad80a8bda1e851a'
  #
  # Returns the new Tweet.
  def tweet(text, source)
    text = (text || '').strip
    tweet = Tweet.create(user: self, source: source, text: text)
    update_timelines(tweet)
    tweet
  end

  # Return a View of this user's tweets ordered newest to oldest. The View
  # can be used to count the tweets or to retrieve some subset of them.
  #
  # Examples
  #
  #   user.tweets.count
  #   # => 2
  #
  #   user.tweets.all
  #   # => [Tweet, Tweet, etc.]
  #
  # Returns a CouchRest::Model::Designs::View of Tweets.
  def tweets
    @tweets ||= Tweet.by_user_id.key(id).descending
  end


  # Return a View of the tweets on the user's timeline ordered newest to oldest.
  #
  # options - The Hash options used to narrow the timeline (default: {}):
  #           :page  - The optional Fixnum page number of the timeline to
  #                    retrieve (default: 0).
  #           :count - The optional Fixnum number of tweets per page
  #                    (default: 20).
  # Examples
  #
  #   user.timeline(page: 1, count: 25).all
  #   # => [Tweet, Tweet, etc.]
  #
  # Returns a CouchRest::Model::Designs::View of Tweets.
  def timeline(options={})
    page  = options[:page] || 0
    count = options[:count] || 20
    TimelineEntry.by_user_id.key(id).descending.page(page).per(count)
  end

  # Retrieve the user's most popular tweets. The more users that star a tweet,
  # the more popular it is. Tweets returned from this method have their 'stars'
  # property set to the number of times a user liked this tweet.
  #
  # Examples
  #
  #   user.popular
  #   # => [Tweet, Tweet, etc.]
  #
  #   user.popular.first.stars
  #   # => 3
  #
  # Returns an Array of Tweets sorted by number of stars.
  def popular
    # view key is [user_id, tweet_id]
    view = Favorite.by_author_id.startkey([id, nil]).endkey([id, 'ZZZZZZZ'])

    # query reduce view to get star counts
    stars = Hash[view.reduce.group.rows.map do |row|
      # key=[user_id, tweet_id], value=stars
      [row['key'][1], row['value']]
    end]

    view.reset!

    # query view again for tweet docs
    view.all.each do |tweet|
      tweet.stars = stars[tweet.id]
    end.sort_by {|tweet| -tweet.stars }
  end

  # Star/favorite a Tweet.
  #
  # tweet - The Tweet this user likes.
  #
  # Returns the new Favorite.
  def favorite(tweet)
    Favorite.create(user: self, tweet: tweet, author: tweet.user)
  end

  # Return a View of this user's favorite tweets ordered newest to oldest. The
  # View can be used to count the tweets or to retrieve some subset of them.
  #
  # Examples
  #
  #   user.favorites.count
  #   # => 2
  #
  #   user.favorites.all
  #   # => [Tweet, Tweet, etc.]
  #
  # Returns a CouchRest::Model::Designs::View of Tweets.
  def favorites
    @favorites ||= Favorite.by_user_id.key(id).descending
  end

  # Return a View of this user's followers ordered newest to oldest. The
  # View can be used to count the followers or to retrieve some subset of them.
  #
  # Examples
  #
  #   user.followers.count
  #   # => 2
  #
  #   user.followers.all
  #   # => [User, User, etc.]
  #
  # Returns a CouchRest::Model::Designs::View of Users.
  def followers
    @followers ||= Follower.by_user_id.key(id).descending
  end

  # Return a View of the Users we're following ordered newest to oldest. The
  # View can be used to count the users or to retrieve some subset of them.
  #
  # Examples
  #
  #   user.following.count
  #   # => 2
  #
  #   user.following.all
  #   # => [User, User, etc.]
  #
  # Returns a CouchRest::Model::Designs::View of Users.
  def following
    @following ||= Follower.by_follower_id.key(id).descending
  end

  # Follow a user so their tweets appear in our timeline.
  #
  # user - The User to follow.
  #
  # Returns a Follower.
  def follow(user)
    Follower.create(user: user, follower: self)
  end

  # Remove a user from our timeline so no future tweets from them will appear.
  #
  # user - The User to remove from our timeline.
  #
  # Returns nothing.
  def unfollow(user)
    if follow = Follower.by_follower_id.key(id)
      follow.destroy
    end
  end

  private

  # Update all of our follower's timelines, as well as our own, with the new
  # Tweet. We would push this job onto a queue for later processing in a real
  # application because this user may have 25 million followers.
  #
  # tweet - The Tweet to add to followers' timelines.
  #
  # Returns nothing.
  def update_timelines(tweet)
    [*followers, self].each do |follower|
      entry = TimelineEntry.new(user: follower, tweet: tweet).to_hash
      tweet.database.bulk_save_doc(entry)
    end
    tweet.database.bulk_save
  end
end
