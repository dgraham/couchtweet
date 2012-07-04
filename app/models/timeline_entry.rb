class TimelineEntry < CouchRest::Model::Base
  belongs_to :user
  belongs_to :tweet

  design do
    # Use the linked document feature in this view so querying the view with
    # +?include_docs=true+ includes the Tweet doc rather than the TimelineEntry
    # doc. We only need to do one query for timeline tweets rather than n + 1
    # queries to pull back all of the Tweet docs. This is a nice way to fake a
    # relational database foreign key relationship.
    view :by_user_id,
      map: %q{
        function(doc) {
          if (doc.type == 'TimelineEntry' && doc.user_id && doc.tweet_id) {
            emit(doc.user_id, {_id: doc.tweet_id});
          }
        }
      },
      reduce: '_count'

    # Index timeline entries by tweet_id so we can find and delete a particular
    # tweet from all timelines.
    view :by_tweet_id,
      map: %q{
        function(doc) {
          if (doc.type == 'TimelineEntry' && doc.user_id && doc.tweet_id) {
            emit(doc.tweet_id, null);
          }
        }
      },
      reduce: '_count'
  end
end
