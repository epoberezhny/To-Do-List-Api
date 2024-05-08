# frozen_string_literal: true

module Api
  module V1
    class TaskSerializer < ApplicationSerializer
      attributes :id, :name, :done, :priority, :deadline, :created_at
    end
  end
end
