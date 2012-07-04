class StatusController < ApplicationController
  before_filter :authenticate, :except => :show

  def show
    @tweet = Tweet.get!(params[:id])
    @user = @tweet.user
  end

  def create
    current_user.tweet(params[:status], 'web')
    redirect_to root_path
  end

  def destroy
    tweet = Tweet.get!(params[:id])
    if tweet && tweet.author?(current_user)
      tweet.destroy
    end
    redirect_to root_path
  end
end
