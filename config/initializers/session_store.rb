# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_timed-tables_session',
  :secret      => 'c9ebd6f88e1b28d9e9f4913e94aa3f5daaf6318a5f9beabe6d193d24867201c0e2e3c3fde6d6480e74e762fee09635dd64100749f4e61bce8bf9430633dee2c3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
