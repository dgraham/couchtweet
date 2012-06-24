class UsersController < ApplicationController
  def show
    @user = User.get(params[:id])
    @tweets = @user.tweets.all
  end
end
