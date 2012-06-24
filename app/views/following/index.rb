module Views
  module Following
    # The mustache view responsible for displaying a list of people the
    # selected user is following.
    class Index < Layouts::Application
      def page_title
        "CouchTweet / People %s is following" % user.id
      end

      def pluralized_following
        pluralize(user.following.count, 'person', 'people')
      end

      def following
        user.following.map do |user|
          {
            id: user.id,
            name: user.name,
            bio: user.bio,
            url: user_path(user.id),
            gravatar: gravatar_for(user.email)
          }
        end
      end
    end
  end
end
