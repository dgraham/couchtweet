# foreman procfile
couchdb: couchdb
redis: redis-server config/redis.conf
worker: rake resque:work QUEUE=*
web: rails server
