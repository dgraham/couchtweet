# A resque job that removes a tweet from all timelines when it's deleted by
# the author.
#
# Examples
#
#   # process delete jobs
#   $ QUEUE=retract_tweets bin/rake resque:work
class RetractTweet
  @queue = :retract_tweets

  def self.perform(tweet_id)
    TimelineEntry.by_tweet_id.key(tweet_id).each do |entry|
      entry.destroy
    end
  end
end
