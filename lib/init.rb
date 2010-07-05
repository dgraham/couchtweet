#!/usr/bin/env ruby

# Run this script to save an initial data set to CouchDB before using the
# Rails application. Tweak the constants at the top of this script to get
# a bigger or smaller data set. For large numbers of users and tweets,
# we probably need to point this script at a Lounge cluster of a few machines.
#
# This creates users with ids of user_0, user_1, etc. and passwords
# of "USER_NAME password". To sign into the Rails application, just use
# user_1 and "user_1 password".
#
# Before running this script, make sure you have CouchDB's uuid algorithm
# set to utc_random in the etc/couchdb/local.ini file. We need that to sort
# tweets in the timeline properly.

$LOAD_PATH.unshift(File.dirname(File.expand_path(__FILE__)))

require 'rubygems'
require 'active_record'
require 'couchrest'
require 'views'

DB = CouchRest.database!("http://127.0.0.1:5984/couchtweet")
USERS = 100
MAX_FOLLOWERS_PER_USER = (USERS * 0.1).to_i
MAX_TWEETS_PER_USER = 100
MAX_FAVORITES_PER_USER = 250

def create_views
  puts "Creating views . . ."
  DB.bulk_save(VIEWS)
end

def create_users(users=USERS)
  puts "Creating #{users} users . . ."
  users.times {|i| DB.bulk_save_doc(user(i)) }
  DB.bulk_save
end

def create_followers(users=USERS, max=MAX_FOLLOWERS_PER_USER)
  puts "Creating up to #{max} followers per user . . ."
  users.times do |user_num|
    count = rand(max)
    start = rand(users - count)
    count.times do |i|
      follower_num = start + i
      unless user_num == follower_num
        DB.bulk_save_doc(follower(user_num, follower_num))
      end
    end
  end
  DB.bulk_save
end

def create_tweets(users=USERS, max=MAX_TWEETS_PER_USER)
  puts "Creating up to #{max} tweets per user . . ."
  users.times do |user_num|
    tweets = Array.new(rand(max)) {|i| tweet(user_num, i) }
    tweets.each {|t| DB.bulk_save_doc(t) }
    DB.bulk_save

    find_followers(user_name(user_num)).each do |f|
      tweets.each do |t|
        DB.bulk_save_doc({
          'user_id' => f['value'],
          'tweet_id' => t['_id'],
          'couchrest-type' => 'TimelineEntry'
        })
      end
    end
    DB.bulk_save

  end
end

def create_favorites(users=USERS, max=MAX_FAVORITES_PER_USER)
  puts "Creating up to #{max} favorite tweets per user . . ."
  users.times do |user_num|
    count = rand(max) + 1
    tweets = []
    while tweets.size < count
      tweets += find_tweets(user_name(rand(users))).map do |row|
        {:id => row['id'], :user_id => row['key']}
      end
    end
    tweets.shuffle!
    count.times {|i| DB.bulk_save_doc(favorite(user_num, tweets[i])) }
    DB.bulk_save
  end
end

def cleanup
  puts "Compacting database in the background"
  DB.bulk_save
  DB.compact!
end

def user(num)
  date = created_at
  name = user_name(num)
  lang = %w[en es de fr]
  location = %w[USA England Spain Germany France]
  {
    '_id' => name,
    'name' => "#{name}'s real name",
    'email' => "#{name}@twitter.int",
    'bio' => "This is the bio text for #{name}.",
    'password' => hmac("#{name} password", name),
    'lang' => lang[rand(lang.size)],
    'location' => location[rand(location.size)],
    'url' => 'http://www.google.com/',
    'protect' => (rand(1000) == 0),
    'verified' => (rand(10000) == 0),
    'created_at' => date,
    'modified_at' => date,
    'couchrest-type' => 'User'
  }
end

def user_name(num)
  "user_#{num}"
end

def created_at
  years = 60 * 60 * 24 * 365 * 3
  date = Time.now - rand(years)
end

def hmac(key, data)
  digest = OpenSSL::Digest::Digest.new("sha512")
  OpenSSL::HMAC.hexdigest(digest, key, data)
end

def follower(user_num, follower_num)
  {
    'user_id' => user_name(user_num),
    'follower_id' => user_name(follower_num),
    'couchrest-type' => 'Follower'
  }
end

def favorite(user_num, tweet_doc)
  {
    'user_id' => user_name(user_num),
    'tweet_id' => tweet_doc[:id],
    'author_id' => tweet_doc[:user_id],
    'couchrest-type' => 'Favorite'
  }
end

def tweet(user_num, tweet_num)
  sources = %w[web TweetDeck Echofon API]
  length = rand(140 - tweet_num.to_s.size) + 1
  text = Array.new(length) {|i| (i % 5 == 0) ? ' ' : 'a' }.join
  {
    'source' => sources[rand(sources.size)],
    'user_id' => user_name(user_num),
    'text' => [tweet_num, text].join,
    'couchrest-type' => 'Tweet'
  }
end

def find_followers(user)
  DB.view('follower/by_user_id', :key => user, :reduce => false)['rows']
end

def find_tweets(user)
  DB.view('tweet/by_user_id', :key => user, :reduce => false, :limit => 50)['rows']
end

create_views
create_users
create_followers
create_tweets
create_favorites
cleanup
puts "Done"

