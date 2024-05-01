# frozen_string_literal: true

module Auth
  def access_token(user:)
    rodauth(user).session_jwt
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
