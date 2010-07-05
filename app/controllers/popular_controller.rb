class PopularController < ApplicationController

  def index
    @user = User.get(params[:user_id])
    @tweets = Favorite.find_by_author_id(@user.id).map do |row|
      [Tweet.get(row[0]), row[1]]
    end
    @tweet_count = Tweet.find_count_by_user_id(@user.id)
    @following_count = Follower.find_following_count(@user.id)
    @follower_count = Follower.find_follower_count(@user.id)
  end

end
