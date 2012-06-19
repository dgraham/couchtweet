# Run +rake db:seed+ to save an initial data set to CouchDB before using the
# web application. Tweak the numbers in +start+ to get a bigger or smaller
# data set. For large numbers of users and tweets, you probably need to point
# this script at a CouchProxy cluster of a few machines.
#
# This creates users with ids of user0, user1, etc. and passwords
# of "USER_NAME password". To sign into the web application use
# user1 and "user1 password".
class Seeds

  # Start seeding random data into the database. Customize the numbers here
  # to get a larger data set.
  #
  # Returns nothing.
  def self.start
    new(users: 25, followers: 5, tweets: 25, favorites: 3).start
  end

  # Creates a new Seeds object to use to populate the database with initial
  # random data.
  #
  # options - The Hash options to configure the seed data (default: {}).
  #           :users     - The optional Fixnum number of users to create
  #                        (default: 25).
  #           :followers - The optional Fixnum max number of followers per user
  #                        (default: 5).
  #           :tweets    - The optional Fixnum max number of tweets per user
  #                        (default: 25).
  #           :favorites - The optional Fixnum max number of stars per tweet
  #                        (default: 3).
  def initialize(options={})
    @users     = options[:users] || 25
    @followers = options[:followers] || 5
    @tweets    = options[:tweets] || 25
    @favorites = options[:favorites] || 3
  end

  # Start seeding random data into the database. This may take a while to run.
  #
  # Returns nothing.
  def start
    puts "Creating #{@users} users . . ."
    users = Array.new(@users) {|ix| user(ix) }

    puts "Creating up to #{@followers} followers per user . . ."
    users.each do |user|
      buddies = users.shuffle.take(rand(@followers))
      buddies.delete(user)
      buddies.each {|buddy| user.follow(buddy) }
    end

    puts "Creating up to #{@tweets} tweets per user . . ."
    users.each do |user|
      tweets = Array.new(rand(@tweets)) { tweet(user) }
      tweets.each do |tweet|
        fans = users.shuffle.take(rand(3))
        fans.each {|fan| fan.favorite(tweet) }
      end
    end

    puts "Compacting database in the background"
    CouchRest::Model::Base.database.compact!
  end

  private

  # Creates a new user in the database with randomly generated attributes.
  #
  # num - The Fixnum user number to use in their user name.
  #
  # Returns the saved User.
  def user(num)
    id = "user#{num}"
    name = words.shuffle.take(2).map {|word| word.capitalize }.join(' ')
    User.create(
      id: id,
      name: name,
      email: "#{id}@example.com",
      bio: "This is the bio text for #{name}.",
      password: "#{id} password",
      lang: %w[de en es fr].sample,
      location: %w[England France Germany Spain USA].sample,
      url: 'http://www.google.com/',
      protect: rand(1000) == 0,
      verified: rand(10000) == 0)
  end

  # Creates a new tweet for the user with random text.
  #
  # user - The User that's tweeting.
  #
  # Returns the saved Tweet.
  def tweet(user)
    length = rand(1..140)
    text = words.shuffle.join(' ')[0..length]
    source = %w[web TweetDeck Tweetbot Twitterific Echofon API].sample
    user.tweet(text, source)
  end

  # Generate some lorem ipsum text to use in tweets and fake users names. This
  # method caches the word list so it's not generated each time. Random
  # sequences of words can be generated like this:
  #
  #   words.shuffle.take(2).join(' ')
  #   # => 'magna sed'
  #
  # Returns an Array of Strings.
  def words
    @words ||= %q{
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque
      faucibus tellus eu magna venenatis eu scelerisque sapien ultrices. Morbi
      viverra, arcu vel lobortis suscipit, magna erat venenatis velit, sit amet
      mattis sapien nisi id dui. Sed sed metus quam. Nulla pellentesque, leo
      sed condimentum tempor, neque sem mattis sem, eget congue nibh augue sit
      amet urna. Quisque hendrerit consequat metus sed lacinia. In sit amet
      velit sit amet nunc euismod tincidunt id at ligula. Donec faucibus lectus
      et justo feugiat a aliquet lacus viverra. Vestibulum ante ipsum primis in
      faucibus orci luctus et ultrices posuere cubilia Curae; Curabitur quis
      justo urna. Integer at lectus ac arcu mattis faucibus ac vel neque. Nulla
      commodo pharetra mauris, ac lobortis turpis feugiat id.
    }.gsub(/[.,;]/, '').split
  end
end
