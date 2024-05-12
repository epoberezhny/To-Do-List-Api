# frozen_string_literal: true

require 'sequel/core'

class RodauthMain < Rodauth::Rails::Auth
  configure do # rubocop:disable Metrics/BlockLength
    domain ENV.fetch('APP_HOST', 'localhost')

    # List of authentication features that are loaded.
    enable :create_account, :login, :logout, :active_sessions, :jwt, :jwt_refresh, :internal_request

    # See the Rodauth documentation for the list of available config options:
    # http://rodauth.jeremyevans.net/documentation.html

    # ==> General
    # Initialize Sequel and have it reuse Active Record's database connection.
    db Sequel.postgres(extensions: :activerecord_connection, keep_reference: false)

    # Avoid DB query that checks accounts table schema at boot time.
    convert_token_id_to_integer? { User.columns_hash['id'].type == :integer }

    # Change prefix of table and foreign key column names from default "account"
    accounts_table :users
    # verify_account_table :user_verification_keys
    # verify_login_change_table :user_login_change_keys
    # reset_password_table :user_password_reset_keys
    active_sessions_table :user_active_session_keys
    active_sessions_account_id_column :user_id
    jwt_refresh_token_table :user_jwt_refresh_keys
    jwt_refresh_token_account_id_column :user_id

    # The secret key used for hashing public-facing tokens for various features.
    # Defaults to Rails `secret_key_base`, but you can use your own secret key.
    # hmac_secret "cab46b2f1733640a6e6078614f6b47868b59ee2d226953bccf0b565d99de49d48ddaefaad560776df8c49548d084f63605c5a89745cb2a834078472542297ed7"

    prefix '/auth'
    create_account_route 'accounts'
    jwt_refresh_route 'refresh'

    # Set JWT secret, which is used to cryptographically protect the token.
    jwt_secret { hmac_secret }
    allow_refresh_with_expired_jwt_access_token? true
    expired_jwt_access_token_status 401
    invalid_jwt_format_error_message { [{ detail: super() }] }
    jwt_refresh_invalid_token_message { [{ detail: super() }] }
    jwt_refresh_without_access_token_message { [{ detail: super() }] }
    expired_jwt_access_token_message { [{ detail: super() }] }

    # Accept only JSON requests.
    only_json? true
    json_response_success_key nil
    json_response_error_key 'errors'

    # Handle login and password confirmation fields on the client side.
    # require_password_confirmation? false
    require_login_confirmation? false

    # Use path prefix for all routes.
    # prefix "/auth"

    # Specify the controller used for view rendering, CSRF, and callbacks.
    rails_controller { RodauthController }

    # Make built-in page titles accessible in your views via an instance variable.
    # title_instance_variable :@page_title

    # Store account status in an integer column without foreign key constraint.
    account_status_column :status

    # Store password hash in a column instead of a separate table.
    account_password_hash_column :password_hash

    # Set password when creating account instead of when verifying.
    # verify_account_set_password? false

    # Change some default param keys.
    login_param 'email'
    # login_confirm_param 'email-confirm'
    password_confirm_param 'password_confirmation'

    # Redirect back to originally requested location after authentication.
    # login_return_to_requested_location? true
    # two_factor_auth_return_to_requested_location? true # if using MFA

    # Autologin the user after they have reset their password.
    # reset_password_autologin? true

    # Delete the account record when the user has closed their account.
    # delete_account_on_close? true

    # Redirect to the app from login and registration pages if already logged in.
    # already_logged_in { redirect login_redirect }

    # ==> Flash
    # Override default flash messages.
    # create_account_notice_flash "Your account has been created. Please verify your account by visiting the confirmation link sent to your email address."
    # require_login_error_flash "Login is required for accessing this page"
    # login_notice_flash nil

    # ==> Validation
    # Override default validation error messages.
    # no_matching_login_message "user with this email address doesn't exist"
    # already_an_account_with_this_login_message "user with this email address already exists"
    # password_too_short_message { "needs to have at least #{password_minimum_length} characters" }
    # login_does_not_meet_requirements_message { "invalid email#{", #{login_requirement_message}" if login_requirement_message}" }

    # Passwords shorter than 8 characters are considered weak according to OWASP.
    password_minimum_length 8
    # bcrypt has a maximum input length of 72 bytes, truncating any extra bytes.
    password_maximum_bytes 72

    # Custom password complexity requirements (alternative to password_complexity feature).
    # password_meets_requirements? do |password|
    #   super(password) && password_complex_enough?(password)
    # end
    # auth_class_eval do
    #   def password_complex_enough?(password)
    #     return true if password.match?(/\d/) && password.match?(/[^a-zA-Z\d]/)
    #     set_password_requirement_error_message(:password_simple, "requires one number and one special character")
    #     false
    #   end
    # end

    # ==> Hooks
    # Validate custom fields in the create account form.
    # before_create_account do
    #   throw_error_status(422, "name", "must be present") if param("name").empty?
    # end

    # Perform additional actions after the account is created.
    # after_create_account do
    #   Profile.create!(account_id: account_id, name: param("name"))
    # end

    # Do additional cleanup after the account is closed.
    # after_close_account do
    #   Profile.find_by!(account_id: account_id).destroy
    # end

    # ==> Deadlines
    # Change default deadlines for some actions.
    # verify_account_grace_period 3.days.to_i
    # reset_password_deadline_interval Hash[hours: 6]
    # verify_login_change_deadline_interval Hash[days: 2]
  end

  private

  def set_field_error(field, message)
    return super unless use_json?

    json_response[json_response_error_key] ||= []
    json_response[json_response_error_key].push(attribute: field, detail: message)
  end

  def set_error_flash(message) # rubocop:disable Naming/AccessorMethodName
    return super unless use_json?

    json_response[json_response_error_key] ||= []
    json_response[json_response_error_key].push(detail: message)
  end

  def _json_response_body(hash)
    return super if json_response_error?

    super(data: hash)
  end

  def _logout_response
    return super unless use_json?
    return super if json_response_error?

    response.status = 204
    return_response
  end
end
