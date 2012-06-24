module Views
  module Welcome
    # The view for the logged-in home page that lists tweets on the user's
    # timeline.
    class Index < Layouts::Application

      def page_title
        'CouchTweet / Home'
      end

      def sidebar
        @sidebar ||= welcome_sidebar
      end
    end
  end
end
