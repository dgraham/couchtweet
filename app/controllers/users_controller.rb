class UsersController < ApplicationController
  def show
    @user = User.get(params[:id])
    @tweets = @user.tweets
    @tweet_count = @user.tweets.count
    @following_count = @user.following.count
    @follower_count = @user.followers.count
  end
end
