class FavoritesController < ApplicationController
  before_filter :authenticate, :except => :index

  def index
    @user = User.get!(params[:user_id])
    @tweets = @user.favorites.all
  end

  def update
    tweet = Tweet.get!(params[:id])
    current_user.favorite(tweet)
    redirect_to user_tweet_path(tweet.user, tweet)
  end
end
