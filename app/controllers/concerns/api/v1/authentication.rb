# frozen_string_literal: true

module Api
  module V1
    module Authentication
      private

      def current_user
        rodauth.rails_account
      end

      def authenticate_user!
        rodauth.require_account
        rodauth.check_active_session
      end
    end
  end
end
