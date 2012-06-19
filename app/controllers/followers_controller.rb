class FollowersController < ApplicationController
  before_filter :authenticate

  def index
    @user = User.get(params[:user_id])
    @followers = @user.followers.all
    @tweet_count = @user.tweets.count
    @following_count = @user.following.count
    @follower_count = @user.followers.count
  end
end
