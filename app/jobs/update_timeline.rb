# A resque job that populates follower timelines with a new tweet. A user
# may have millions of followers, so we don't want to update all of their
# timelines in the rails app when we receive the tweet.
#
# Examples
#
#   # process timeline jobs
#   $ QUEUE=timelines bin/rake resque:work
class UpdateTimeline
  @queue = :timelines

  def self.perform(tweet_id)
    Tweet.find(tweet_id).broadcast
  end
end
