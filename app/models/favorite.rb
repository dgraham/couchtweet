class Favorite < CouchRest::Model::Base
  belongs_to :user
  belongs_to :author, :class_name => User
  belongs_to :tweet

  design do
    view :by_user_id,
      map: %q{
        function(doc) {
          if (doc.type == 'Favorite' && doc.user_id && doc.tweet_id) {
            emit(doc.user_id, {_id: doc.tweet_id});
          }
        }
      },
      reduce: '_count'

    view :by_tweet_id,
      map: %q{
        function(doc) {
          if (doc.type == 'Favorite' && doc.user_id && doc.tweet_id) {
            emit(doc.tweet_id, doc.user_id);
          }
        }
      },
      reduce: '_count'

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
end
