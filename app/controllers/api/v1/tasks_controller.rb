# frozen_string_literal: true

module Api
  module V1
    class TasksController < ApplicationController
      load_and_authorize_resource :project
      load_and_authorize_resource :task, through: :project

      def index
        render_json(@tasks)
      end

      def show
        render_json(@task)
      end

      def create
        process_record(@task, location: -> { api_v1_project_task_url(@project, @task) })
      end

      def update
        process_record(@task, params: task_params)
      end

      def destroy
        @task.destroy
      end

      private

      def task_params
        params.permit(:name, :done, :priority, :deadline)
      end

      def serializer_class
        Api::V1::TaskSerializer
      end
    end
  end
end
