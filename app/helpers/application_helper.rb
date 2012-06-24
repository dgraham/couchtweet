# These helper methods are mixed into all mustache view classes. They rely on
# the view providing `user` and `current_user` methods.
module ApplicationHelper
  def datef(time)
    suffixes = %w[th st nd rd th th th th th th]
    if time < 1.day.ago
      time = time.strftime("%I:%M %p %b %d")
      time.slice!(0) if time[0] == '0'
      time + suffixes[time[-1].to_i]
    else
      time_ago_in_words(time) + " ago"
    end
  end

  def current_user_path
    user_path(current_user.id)
  end

  def current_user_status_path
    user_status_path(current_user.id)
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

  # Convert a list of tweets into a Hash suitable for a template. The
  # controller that renders this view must populate a @tweets Array with
  # Tweet objects.
  #
  # Returns a Hash of tweet view data:
  #  :tweet            - The Tweet object.
  #  :link_to_author   - The <a href> html String to the user's profile.
  #  :link_to_tweet    - The <a href> html String to the tweet's page.
  #  :pluralized_stars - The String of how many people liked this Tweet
  #                      (e.g. '12 people').
  def tweets
    @tweets.map do |tweet|
      {
        tweet: tweet,
        link_to_author: link_to(tweet.user_id, user_path(tweet.user_id)),
        link_to_tweet: link_to(datef(tweet.created_at), user_statu_path(tweet.user_id, tweet.id)),
        pluralized_stars: pluralize(tweet.stars, 'person', 'people')
      }
    end
  end
end
