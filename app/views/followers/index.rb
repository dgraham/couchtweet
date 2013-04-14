module Views
  module Followers
    # Displays a list of people the selected user is following.
    class Index < Layouts::Application
      def page_title
        "CouchTweet / People who follow %s" % user.id
      end

      def pluralized_followers
        pluralize(user.followers.count, 'follower')
      end

      def followers
        UserExhibit.decorate(user.followers.all, self).map(&:to_hash)
      end
    end
  end
end

