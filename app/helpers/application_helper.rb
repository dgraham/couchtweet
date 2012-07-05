# These helper methods are mixed into all mustache view classes. They rely on
# the view providing `user` and `current_user` methods.
module ApplicationHelper
  def current_user_path
    user_path(current_user.id)
  end

  def current_user_status_path
    user_tweets_path(current_user.id)
  end

  def profile_path
    user_path(user.id)
  end

  def favorites_path
    user_favorites_path(user.id)
  end

  def popular_path
    user_popular_index_path(user.id)
  end

  def following_path
    user_following_index_path(user.id)
  end

  def followers_path
    user_followers_path(user.id)
  end

  def tweet_count
    user.tweets.count
  end

  def follower_count
    user.followers.count
  end

  def following_count
    user.following.count
  end

  def favorite_count
    user.favorites.count
  end

  def user_id
    user.id
  end

  def user_name
    user.name
  end

  def user_gravatar
    gravatar_for(user.email)
  end
end
