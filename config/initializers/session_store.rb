# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_aai_home_session',
  :secret      => '9209d310f3369fcea79dd9ac9bde35f4bdf80f26f797102de5da178f140f2901568a0c5d6c5a22a697b9673b385b73d9fda455ff1898e74f1e079aeb86c0fb11'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
