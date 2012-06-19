class Follower < CouchRest::Model::Base
  belongs_to :user
  belongs_to :follower, :class_name => User

  design do
    view :by_user_id,
      map: %q{
        function(doc) {
          if (doc.type == 'Follower' && doc.user_id && doc.follower_id) {
            emit(doc.user_id, {_id: doc.follower_id});
          }
        }
      },
      reduce: '_count'

    view :by_follower_id,
      map: %q{
        function(doc) {
          if (doc.type == 'Follower' && doc.user_id && doc.follower_id) {
            emit(doc.follower_id, {_id: doc.user_id});
          }
        }
      },
      reduce: '_count'
  end
end
