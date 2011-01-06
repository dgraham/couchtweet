class WelcomeController < ApplicationController
  before_filter :authenticate

  def index
    @tweets = TimelineEntry.find_recent_tweets(@current_user.id)
    @tweet_count = Tweet.find_count_by_user_id(@current_user.id)
    @follower_count = Follower.find_follower_count(@current_user.id)
    @following_count = Follower.find_following_count(@current_user.id)
  end
end
