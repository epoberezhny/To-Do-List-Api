# frozen_string_literal: true

module Api
  module V1
    class CommentsController < Api::V1::ApplicationController
      load_and_authorize_resource :project
      load_and_authorize_resource :task,    through: :project
      load_and_authorize_resource :comment, through: :task

      def index
        render json: @comments
      end

      def show
        render json: @comment
      end

      def create
        location_lambda = -> { api_v1_project_task_comment_url(@project, @task, @comment) }

        process_record @comment, location: location_lambda, &:reload
      end

      def update
        process_record @comment, params: comment_params
      end

      def destroy
        @comment.destroy
      end

      private

      def comment_params
        params.permit(:text, :attachment)
      end
    end
  end
end
