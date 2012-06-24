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
        user.followers.map do |follower|
          {
            id: follower.id,
            name: follower.name,
            bio: follower.bio,
            url: user_path(follower.id),
            gravatar: gravatar_for(follower.email)
          }
        end
      end
    end
  end
end
