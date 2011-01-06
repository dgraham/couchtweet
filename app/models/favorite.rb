class Favorite < CouchRest::ExtendedDocument
  use_database TWEETS_DB

  property :user_id
  property :author_id
  property :tweet_id

  def self.find_count_by_user_id(user_id)
    rows = by_user_id(:key => user_id)
    rows.empty? ? 0 : rows.first['value']
  end

  def self.find_count_by_tweet_id(tweet_id)
    rows = by_tweet_id(:key => tweet_id)
    rows.empty? ? 0 : rows.first['value']
  end
  
  def self.find_by_user_id(user_id)
    rows = by_user_id(:key => user_id, :include_docs => true, :reduce => false,
      :descending => true)
    rows.map {|row| Tweet.new(row['doc']) }
  end

  def self.find_by_author_id(author_id)
    rows = by_author_id(:startkey => [author_id, nil],
      :endkey => [author_id, 'ZZZZZZZ'], :group => true)
    rows.map {|row| [row['key'][1], row['value']] }
  end

  private

  def self.by_user_id(args={})
    database.view('favorite/by_user_id', args)['rows']
  end

  def self.by_tweet_id(args={})
    database.view('favorite/by_tweet_id', args)['rows']
  end

  def self.by_author_id(args={})
    database.view('favorite/by_author_id', args)['rows']
  end
end
