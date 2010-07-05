class Follower < CouchRest::ExtendedDocument
  use_database TWEETS_DB

  property :user_id
  property :follower_id

  def self.find_follower_count(user_id)
    rows = by_user_id(:key => user_id)
    rows.empty? ? 0 : rows.first['value']
  end

  def self.find_following_count(user_id)
    rows = by_follower_id(:key => user_id)
    rows.empty? ? 0 : rows.first['value']
  end

  def self.find_followers(user_id)
    rows = by_user_id(:key => user_id, :include_docs => true,
      :reduce => false, :descending => true)
    rows.map {|row| Follower.new(row['doc']) }
  end

  def self.find_following(user_id)
    rows = by_follower_id(:key => user_id, :include_docs => true,
      :reduce => false, :descending => true)
    rows.map {|row| Follower.new(row['doc']) }
  end

  private

  def self.by_user_id(args={})
    database.view('follower/by_user_id', args)['rows']
  end

  def self.by_follower_id(args={})
    database.view('follower/by_follower_id', args)['rows']
  end

end
