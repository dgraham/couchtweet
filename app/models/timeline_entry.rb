class TimelineEntry < CouchRest::ExtendedDocument
  use_database TWEETS_DB

  property :user_id
  property :tweet_id

  def self.find_recent_tweets(user_id)
    rows = view(:key => user_id, :include_docs => true, :limit => 20,
      :descending => true)
    rows.map {|row| Tweet.new(row['doc']) }
  end

  private

  def self.view(args={})
    database.view('timeline/by_user_id', args)['rows']
  end
end
