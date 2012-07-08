class Favorite < CouchRest::Model::Base
  belongs_to :user
  belongs_to :author, :class_name => User
  belongs_to :tweet

  after_create :notify_favorite

  design do
    # Index favorites by the user who liked the tweet so we can show a list of
    # each user's favorite tweets.
    view :by_user_id,
      map: %q{
        function(doc) {
          if (doc.type == 'Favorite' && doc.user_id && doc.tweet_id) {
            emit(doc.user_id, {_id: doc.tweet_id});
          }
        }
      },
      reduce: '_count'

    # Index favorites by the tweet that was starred so we can show how many
    # people liked a particular tweet. The reduce view gives us the number of
    # stars for each tweet.
    view :by_tweet_id,
      map: %q{
        function(doc) {
          if (doc.type == 'Favorite' && doc.user_id && doc.tweet_id) {
            emit(doc.tweet_id, doc.user_id);
          }
        }
      },
      reduce: '_count'

    # Index favorites by author and tweet so we can list each user's most
    # popular tweets. The reduce view gives us a count of how many people
    # liked each tweet.
    view :by_author_id,
      map: %q{
        function(doc) {
          if (doc.type == 'Favorite' && doc.author_id && doc.tweet_id) {
            emit([doc.author_id, doc.tweet_id], {_id: doc.tweet_id});
          }
        }
      },
      reduce: '_count'
  end

  private

  # Queue a resque job to email the user that their tweet was marked as a
  # favorite.
  #
  # Returns nothing.
  def notify_favorite
    return if user == author # vanity
    Resque.enqueue(NotifyFavorite, id)
  end
end
