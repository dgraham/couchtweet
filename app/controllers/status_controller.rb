class StatusController < ApplicationController
  before_filter :authenticate, :only => :create

  def show
    @tweet = Tweet.get(params[:id])
    @user = @tweet.user
  end

  def create
    current_user.tweet(params[:status], 'web')
    redirect_to root_path
  end
end
