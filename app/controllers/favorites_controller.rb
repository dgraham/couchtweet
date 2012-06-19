class FavoritesController < ApplicationController
  def index
    @user = User.get(params[:user_id])
    @tweets = @user.favorites.all
    @tweet_count = @user.tweets.count
    @following_count = @user.following.count
    @follower_count = @user.followers.count
  end
end
