class Follower < CouchRest::Model::Base
  belongs_to :user
  belongs_to :follower, :class_name => User

  after_create :notify_following

  design do
    # Index follower relationships by user_id so we can find a list of a user's
    # followers.
    view :by_user_id,
      map: %q{
        function(doc) {
          if (doc.type == 'Follower' && doc.user_id && doc.follower_id) {
            emit(doc.user_id, {_id: doc.follower_id});
          }
        }
      },
      reduce: '_count'

    # Index by follower_id so we can find a list of users a user is following.
    view :by_follower_id,
      map: %q{
        function(doc) {
          if (doc.type == 'Follower' && doc.user_id && doc.follower_id) {
            emit(doc.follower_id, {_id: doc.user_id});
          }
        }
      },
      reduce: '_count'

    # Index that allows us to quickly determine if a follower relationship
    # exists between two users.
    view :by_user_id_and_follower_id,
      map: %q{
        function(doc) {
          if (doc.type == 'Follower' && doc.user_id && doc.follower_id) {
            emit([doc.user_id, doc.follower_id], null);
          }
        }
      }
  end

  private

  # Queue a resque job to email the user about their new follower.
  #
  # Returns nothing.
  def notify_following
    Resque.enqueue(NotifyFollowing, user.id, follower.id)
  end
end
