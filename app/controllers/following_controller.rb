class FollowingController < ApplicationController
  before_filter :authenticate

  def index
    @user = User.get(params[:user_id])
    @following = @user.following.all
    @tweet_count = @user.tweets.count
    @following_count = @user.following.count
    @follower_count = @user.followers.count
  end
end
