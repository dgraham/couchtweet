class User < CouchRest::ExtendedDocument
  use_database TWEETS_DB

  property :name
  property :bio, :length => 1..160
  property :url
  property :email
  property :password
  property :location
  property :lang
  property :tz
  property :protect
  property :verified

  timestamps!
end
