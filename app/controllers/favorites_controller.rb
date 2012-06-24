class FavoritesController < ApplicationController
  def index
    @user = User.get(params[:user_id])
    @tweets = @user.favorites.all
  end
end
