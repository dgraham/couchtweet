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

      def link_to_author
        link_to(user.id, profile_path)
      end

      def author_name
        user.name
      end
    end
  end
end
