Devise.setup do |config|

  # with default "from" parameter.
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # available as additional gems.
  require 'devise/orm/active_record'

  # to authenticate or find a user. Default is :email.
  config.case_insensitive_keys = [:email]

  # Configure which authentication keys should have whitespace stripped.
  # These keys will have whitespace before and after removed upon creating or
  # modifying a user and when used to authenticate or find a user. Default is :email.
  config.strip_whitespace_keys = [:email]

  # passing skip: :sessions to `devise_for` in your config/routes.rb
  config.skip_session_storage = [:http_auth]

  # a value of 20 is already extremely slow: approx. 60 seconds for 1 calculation).
  config.stretches = Rails.env.test? ? 1 : 12

  # unconfirmed_email column, and copied to email column on successful confirmation.
  config.reconfirmable = true


  # Invalidates all the remember me tokens when the user signs out.
  config.expire_all_remember_me_on_sign_out = true

  # Range for password length.
  config.password_length = 6..128

  # Email regex used to validate email formats. It simply asserts that
  # one (and only one) @ exists in the given string. This is mainly
  # to give user feedback and not to assert the e-mail validity.
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # change their passwords.
  config.reset_password_within = 6.hours

  # customization for api
  config.navigational_formats = []

  config.jwt do |jwt|
  jwt.secret = Rails.application.credentials.fetch(:secret_key_base)
  jwt.dispatch_requests = [
    ['POST', %r{^/login$}]
  ]
  jwt.revocation_requests = [
    ['DELETE', %r{^/logout$}]
  ]
  jwt.expiration_time = 30.minutes.to_i
end

  # The default HTTP method used to sign out a resource. Default is :delete.
  config.sign_out_via = :delete

  # Note: These might become the new default in future versions of Devise.
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

end
