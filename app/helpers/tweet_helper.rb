# Helper methods for turning Tweets into other formats suitable for mustache
# views or JSON API calls. These methods are mixed into the mustache view
# classes.
module TweetHelper
  # Convert a list of tweets into a Hash suitable for a template. The
  # controller that renders this view must populate a @tweets Array with
  # Tweet objects.
  #
  # The array may contain nil entries if the tweet has been deleted, but the
  # user's timeline still references it. This method ignores nil tweets while
  # the RetractTweet resque job updates the timeline.
  #
  # Returns a Hash of tweet view data:
  #  :text       - The tweet's content String.
  #  :source     - The app String used to post the tweet.
  #  :url        - The String url to the tweet.
  #  :created_at - The Hash of timstamp info:
  #    :millis   - The timestamp in milliseconds.
  #    :date     - The formatted date String (e.g. '24 Jun').
  #    :full     - The formatted full date String (e.g. '11:33 AM - 24 Jun 12').
  #  :favorites  - The Hash of favorite info. Not all tweet views populate the
  #                favorite count.
  #    :any      - A Boolean true if anyone has starred this tweet.
  #    :count    - The Fixnum count of stars.
  #    :text     - How many people liked this tweet (e.g. '12 people').
  #  :author     - The Hash of user info:
  #    :id       - The user id String.
  #    :name     - The user's full name String.
  #    :url      - The url String to their profile.
  #    :gravatar - The url String to their Gravatar image.
  def tweets
    @tweets.compact.map do |tweet|
      {
        text: tweet.text,
        source: tweet.source,
        url: user_statu_path(tweet.user.id, tweet.id),
        created_at: {
          millis: (tweet.created_at.to_f * 1000).to_i,
          date: datef(tweet.created_at),
          full: full_date(tweet.created_at)
        },
        favorites: {
          any: (tweet.stars || 0) > 0,
          count: tweet.stars,
          text: pluralize(tweet.stars, 'person', 'people')
        },
        author: {
          id: tweet.user.id,
          name: tweet.user.name,
          url: user_path(tweet.user.id),
          gravatar: gravatar_for(tweet.user.email)
        }
      }
    end
  end
end
