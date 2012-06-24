module Views
  module Favorites
    # The mustache view class for app/templates/favorites/index.mustache.
    # Instance variables populated by the FavoritesController. Displays a list
    # of the selected user's favorite tweets.
    class Index < Layouts::Application
      def page_title
        "CouchTweet / %s's Favorites" % user.id
      end
    end
  end
end
