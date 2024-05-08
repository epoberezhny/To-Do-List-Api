# frozen_string_literal: true

module Api
  module V1
    class CommentSerializer < ApplicationSerializer
      attributes :id, :text, :attachment_url, :created_at
    end
  end
end
