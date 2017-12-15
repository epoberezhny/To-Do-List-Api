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

  private

  def save_record(record:, location:)
    if record.save
      yield record if block_given?
      render json: record, status: :created, location: location.call
    else
      render json: record.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update_record(record:, params:)
    if record.update(params)
      render json: record
    else
      render json: record.errors.full_messages, status: :unprocessable_entity
    end
  end
end
