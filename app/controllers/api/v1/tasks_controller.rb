# frozen_string_literal: true

module Api
  module V1
    class TasksController < Api::V1::ApplicationController
      load_and_authorize_resource :project
      load_and_authorize_resource :task, through: :project

      def index
        render json: @tasks
      end

      def show
        render json: @task
      end

      def create
        process_record @task, location: -> { api_v1_project_task_url(@project, @task) }
      end

      def update
        process_record @task, params: task_params
      end

      def destroy
        @task.destroy
      end

      private

      def task_params
        params.permit(:name, :done, :priority, :deadline)
      end
    end
  end
end
