class WelcomeController < ApplicationController
  before_filter :authenticate

  def index
    @tweets = current_user.timeline.all
    @tweet_count = current_user.tweets.count
    @follower_count = current_user.followers.count
    @following_count = current_user.following.count
  end
end
