class FollowersController < ApplicationController
  def index
    @user = User.get(params[:user_id])
  end
end
