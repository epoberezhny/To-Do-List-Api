# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ApplicationController
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

      def process_record(record, **options)
        new_record = record.new_record?

        record.assign_attributes(options[:params]) unless new_record

        if record.save
          render json: record and return unless new_record

          yield record if block_given?
          render json: record, status: :created, location: options[:location].call
        else
          render json: record.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end
end
