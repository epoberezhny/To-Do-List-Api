class Api::V1::ApplicationController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  include CanCan::ControllerAdditions

  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do
    head :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end
end
