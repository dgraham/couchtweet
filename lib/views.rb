# Define all CouchDB map/reduce views here and let init.rb load
# them into the database. It would be nice if we could let CouchRest
# do this for us, but it creates extra views like 'all', which we
# definitely don't want.
#
# Many of the reduce functions are defined using CouchDB's built-in
# _count Erlang function. This runs much faster than defining the same
# function in JavaScript. We also have access to the _sum and _stats
# built-ins if we need them.
#
# We use the linked document feature in the timeline/by_user_id view so
# when we query that view with ?include_docs=true, CouchDB includes the
# Tweet doc rather than the TimelineEntry doc. We only need to do one
# query for timeline tweets rather than n + 1 queries to pull back all
# of the Tweet docs. This is a nice way to fake a relational database
# foreign key relationship.
#
# Notice that we don't use any created_at doc attribute in the map
# keys for sorting. CouchDB sorts views by key, which is actually
# [your_key, doc_id]. We have to configure CouchDB with a uuid
# algorithm of utc_random for this to work. Configure utc_random in
# the etc/couchdb/local.ini file:
# [uuids]
# algorithm = utc_random
#
# This is a clever way to save disk space and get tweets sorted by
# date because the created_at timestamp is encoded in the doc id. We don't
# need a separate attribute in our docs to track created time. We just
# need to parse out the time from the id (see Tweet#created_at).
VIEWS = [
  {
    '_id' => '_design/user',
    :views => {
      :by_lang => {
        :map => "
          function(doc) {
            if (doc['couchrest-type'] == 'User' && doc.lang) {
              emit(doc.lang, null);
            }
          }
        ",
        :reduce => "_count"
      },
      :by_location => {
        :map => "
          function(doc) {
            if (doc['couchrest-type'] == 'User' && doc.location) {
              emit(doc.location, null);
            }
          }
        ",
        :reduce => "_count"
      }
    }
  },
  {
    '_id' => '_design/timeline',
    :views => {
      :by_user_id => {
        :map => "
          function(doc) {
            if (doc['couchrest-type'] == 'TimelineEntry' && doc.user_id && doc.tweet_id) {
              emit(doc.user_id, {_id: doc.tweet_id});
            }
          }
        "
      }
    }
  },
  {
    '_id' => '_design/follower',
    :views => {
      :by_user_id => {
        :map => "
          function(doc) {
            if (doc['couchrest-type'] == 'Follower' && doc.user_id && doc.follower_id) {
              emit(doc.user_id, doc.follower_id);
            }
          }
        ",
        :reduce => "_count"
      },
      :by_follower_id => {
        :map => "
          function(doc) {
            if (doc['couchrest-type'] == 'Follower' && doc.user_id && doc.follower_id) {
              emit(doc.follower_id, doc.user_id);
            }
          }
        ",
        :reduce => "_count"
      }
    }
  },
  {
    '_id' => '_design/tweet',
    :views => {
      :by_user_id => {
        :map => "
          function(doc) {
            if (doc['couchrest-type'] == 'Tweet' && doc.user_id) {
              emit(doc.user_id, null);
            }
          }
        ",
        :reduce => "_count"
      }
    }
  },
  {
    '_id' => '_design/favorite',
    :views => {
      :by_user_id => {
        :map => "
          function(doc) {
            if (doc['couchrest-type'] == 'Favorite' && doc.user_id && doc.tweet_id) {
              emit(doc.user_id, {_id: doc.tweet_id});
            }
          }
        ",
        :reduce => "_count"
      },
      :by_tweet_id => {
        :map => "
          function(doc) {
            if (doc['couchrest-type'] == 'Favorite' && doc.user_id && doc.tweet_id) {
              emit(doc.tweet_id, doc.user_id);
            }
          }
        ",
        :reduce => "_count"
      },
      :by_author_id => {
        :map => "
          function(doc) {
            if (doc['couchrest-type'] == 'Favorite' && doc.author_id && doc.tweet_id) {
              emit([doc.author_id, doc.tweet_id], null);
            }
          }
        ",
        :reduce => "_count"
      }
    }
  }
]

