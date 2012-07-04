class Tweet < CouchRest::Model::Base
  belongs_to :user

  property :source, String
  property :text,   String

  validates_length_of :source, in: 1..255
  validates_length_of :text,   in: 1..140

  after_create :update_timelines
  after_destroy :retract_tweet

  attr_accessor :stars

  design do
    view :by_user_id,
      map: %q{
        function(doc) {
          if (doc.type == 'Tweet' && doc.user_id) {
            emit(doc.user_id, null);
          }
        }
      },
      reduce: '_count'
  end

  # Determine whether the User created this Tweet.
  #
  # user - Check if this User is the author.
  #
  # Returns true if the User authored this Tweet.
  def author?(user)
    self.user == user
  end

  # Parse the created timestamp from the document's id.
  #
  # All document ids are encoded with a timestamp because we're running CouchDB
  # with the utc_random uuids algorithm. This saves disk space because we don't
  # have to store a separate created_at field for every tweet. It also gives
  # us tweets stored and sorted by date because CouchDB sorts views by key.
  #
  # Returns the created Time.
  def created_at
    # parse date from utc_random generated id
    Time.at(id[0, 14].to_i(16) / 1000 / 1000).utc
  end

  # Return a View of this tweet's favorites. The View can be used to count the
  # stars or to retrieve some subset of them.
  #
  # Examples
  #
  #   tweet.favorites.count
  #   # => 2
  #
  #   tweet.favorites.all
  #   # => [Favorite, Favorite, etc.]
  #
  # Returns a CouchRest::Model::Designs::View.
  def favorites
    @favorites ||= Favorite.by_tweet_id.key(id)
  end

  # Broadcast the tweet to the author's followers so it will appear on their
  # timelines. This method should be called from a resque background job in
  # case the user has millions of followers that need to be notified.
  #
  # Returns nothing.
  def broadcast
    user.followers.each do |follower|
      entry = TimelineEntry.new(user: follower, tweet: self).to_hash
      self.database.bulk_save_doc(entry)
    end
    self.database.bulk_save
  end

  private

  # Queue a resque job to update the author's follower timelines. Update the
  # author's timeline here so the new tweet will appear after a page refresh.
  #
  # Returns nothing.
  def update_timelines
    TimelineEntry.create(user: user, tweet: self)
    Resque.enqueue(UpdateTimeline, id)
  end

  # Queue a resque job to delete this tweet from all timelines.
  #
  # Returns nothing.
  def retract_tweet
    Resque.enqueue(RetractTweet, id)
  end
end
