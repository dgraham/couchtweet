class Tweet < CouchRest::ExtendedDocument
  use_database TWEETS_DB

  property :source
  property :user_id
  property :text, :length => 1..140

  def created_at
    # parse date from utc_random generated id
    Time.at(id[0, 14].to_i(16) / 1000 / 1000).utc
  end

  def self.find_count_by_user_id(user_id)
    rows = view(:key => user_id)
    rows.empty? ? 0 : rows.first['value']
  end
  
  def self.find_by_user_id(user_id)
    rows = view(:key => user_id, :include_docs => true, :limit => 20,
      :reduce => false, :descending => true)
    rows.map {|row| Tweet.new(row['doc']) }
  end

  # Override save so we don't use CouchRest's uuid cache. Let CouchDB give
  # us a uuid so we can use it to determine the created_at time of the
  # tweet.
  def save
    results = database.bulk_save([self], false)
    self['_id'] = results.first['id']
    mark_as_saved
    true
  end

  private
  def self.view(args={})
    database.view('tweet/by_user_id', args)['rows']
  end

end
