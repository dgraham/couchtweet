class FollowingController < ApplicationController
  before_filter :authenticate, :except => :index

  def index
    @user = User.get!(params[:user_id])
  end

  def create
    user = User.get!(params[:user_id])
    current_user.follow(user)
    redirect_to user_path(user)
  end

  def destroy
    user = User.get!(params[:user_id])
    current_user.unfollow(user)
    redirect_to user_path(user)
  end
end
