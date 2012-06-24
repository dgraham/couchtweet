class PopularController < ApplicationController
  def index
    @user = User.get(params[:user_id])
    @tweets = @user.popular
  end
end
