Devise.setup do |config|
  config.secret_key = '5f48d2956109522f76a02cdf4c34f76e114245126dc18702c72363a34f77926301dc69a88225fe2dccf0ef8075cffe3296a41467b584d5e1811444fbbf6e2faa'
  config.http_authenticatable_on_xhr = false
  config.navigational_formats = ["*/*", :html, :json]
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
end
