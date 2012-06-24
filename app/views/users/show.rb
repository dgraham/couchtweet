module Views
  module Users
    # Displays a user's profile page with a list of their most recent tweets.
    class Show < Layouts::Application
      def page_title
        "%s (%s) on CouchTweet" % [user.name, user.id]
      end
    end
  end
end
