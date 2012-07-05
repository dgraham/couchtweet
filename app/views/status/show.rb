module Views
  module Status
    # Displays a single tweet with no sidebar. The controller must populate
    # @tweet and @user instance variables for this view.
    class Show < Layouts::Application

      attr_reader :tweet

      def page_title
        "CouchTweet / %s: %s" % [user.id, truncate(tweet.text, length: 30)]
      end

      def sidebar
        false
      end

      def created_at
        datef(tweet.created_at)
      end

      def liked
        tweet.favorites.count > 0
      end

      def pluralized_favorites
        pluralize(tweet.favorites.count, 'person', 'people')
      end

      def link_to_delete
        if tweet.author?(current_user)
          url = user_tweet_path(tweet.user, tweet)
          link_to(delete_image_tag + 'Delete', url, :method => :delete)
        end
      end

      def link_to_favorite
        if current_user
          url = user_favorite_path(current_user, tweet)
          link_to(star_image_tag + 'Favorite', url, :method => :put)
        end
      end
    end
  end
end
