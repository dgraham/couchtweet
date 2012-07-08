module Views
  module Users
    # Displays a user's profile page with a list of their most recent tweets.
    class Show < Layouts::Application
      def page_title
        "%s (%s) on CouchTweet" % [user.name, user.id]
      end

      # Generate a link to follow/unfollow the user.
      #
      # Returns an HTML `a` tag String to the follow or unfollow actions
      # depending on whether the current user is already following the user or
      # not.
      def link_to_follow
        return if !current_user || current_user == user
        if current_user.following?(user)
          url = user_following_path(user, current_user)
          link_to('Unfollow', url, :method => :delete, :class => 'unfollow')
        else
          link_to('Follow', following_path, :method => :create, :class => 'follow')
        end
      end
    end
  end
end
