# frozen_string_literal: true

module Api
  module V1
    class ProjectSerializer < ApplicationSerializer
      attributes :id, :name, :created_at
    end
  end
end
