class UsersController < ApplicationController
  def show
    @user = User.get(params[:id])
    @tweets = Tweet.find_by_user_id(@user.id)
    @tweet_count = Tweet.find_count_by_user_id(@user.id)
    @following_count = Follower.find_following_count(@user.id)
    @follower_count = Follower.find_follower_count(@user.id)
  end
end
