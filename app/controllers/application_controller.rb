# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def current_user
    rodauth.rails_account
  end

  def authenticate_user!
    rodauth.require_account
    rodauth.check_active_session
  end
end
