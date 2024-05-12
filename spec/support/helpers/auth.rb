# frozen_string_literal: true

module Auth
  def access_token(user:)
    rodauth(user).session_jwt
  end

  def refresh_token(user:)
    rodauth(user).send(:generate_refresh_token).tap do |token|
      rodauth(user).send(:set_jwt_refresh_token_hmac_session_key, token)
    end
  end

  def login(user:)
    rodauth(user).login_session('password')
  end

  private

  def rodauth(account)
    @rodauth_instances ||= {}
    @rodauth_instances[account] ||= Rodauth::Rails.rodauth(account:)
  end
end
