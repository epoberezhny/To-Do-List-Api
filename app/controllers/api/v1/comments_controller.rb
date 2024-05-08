# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      load_and_authorize_resource :project
      load_and_authorize_resource :task, through: :project
      load_and_authorize_resource :comment, through: :task

      def index
        render_json(@comments)
      end

      def show
        render_json(@comment)
      end

      def create
        location = -> { api_v1_project_task_comment_url(@project, @task, @comment) }

        process_record(@comment, location:)
      end

      def update
        process_record(@comment, params: comment_params)
      end

      def destroy
        @comment.destroy
      end

      private

      def comment_params
        params.permit(:text, :attachment)
      end

      def serializer_class
        Api::V1::CommentSerializer
      end
    end
  end
end
