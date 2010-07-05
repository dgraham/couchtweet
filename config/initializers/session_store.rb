# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_couchtweet_session',
  :secret      => '76aeb3933c3d718df5a2635e175ff0d0795513b8562a2c7cfc45793c19ca0903ad76c64dd60936aebb614336cb6b358b528cfb87ae615e20df885acf9da47d3e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
