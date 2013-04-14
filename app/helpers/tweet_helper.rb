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
  # Returns an Array of tweet view Hashes.
  def tweets
    TweetExhibit.decorate(@tweets, self).map(&:to_hash)
  end
end

