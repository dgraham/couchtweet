class StatusController < ApplicationController
  before_filter :authenticate, :only => :create

  def show
    @tweet = Tweet.get(params[:id])
    @user = User.get(@tweet.user_id)
    @favorite_count = Favorite.find_count_by_tweet_id(@tweet.id)
  end

  def create
    tweet = Tweet.new(
      :source => 'web',
      :user_id => @current_user.id,
      :text => params[:status])
    tweet.save
    update_timeline(tweet)
    redirect_to root_path
  end

  private

  # We would push this job onto a queue for later processing
  # in a real application because this user may have 5 million
  # followers.
  def update_timeline(tweet)
    entries = Follower.find_followers(tweet.user_id).map do |f|
      TimelineEntry.new(:user_id => f.follower_id, :tweet_id => tweet.id)
    end
    while (batch = entries.slice!(0, 1000)).any?
      # don't use couchrest uuid cache
      tweet.database.bulk_save(batch, false)
    end
  end
end
