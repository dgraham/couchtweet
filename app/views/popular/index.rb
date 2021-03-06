module Views
  module Popular
    # Displays a list of a user's most popular tweets with how many people
    # marked them as a favorite.
    class Index < Layouts::Application
      def page_title
        "CouchTweet / %s's popular tweets" % user.id
      end
    end
  end
end
