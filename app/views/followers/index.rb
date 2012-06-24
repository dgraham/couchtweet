module Views
  module Followers
    # Displays a list of people the selected user is following.
    class Index < Layouts::Application
      def pluralized_followers
        pluralize(user.followers.count, 'follower')
      end

      def followers
        user.followers.map do |follower|
          link = link_to("@#{follower.id}", user_path(follower.id))
          {user: follower, link_to_user: link}
        end
      end
    end
  end
end
