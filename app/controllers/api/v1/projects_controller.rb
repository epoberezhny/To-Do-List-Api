# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApplicationController
      load_and_authorize_resource

      def index
        render_json(@projects)
      end

      def show
        render_json(@project)
      end

      def create
        process_record(@project, location: -> { api_v1_project_url(@project) })
      end

      def update
        process_record(@project, params: project_params)
      end

      def destroy
        @project.destroy
      end

      private

      def project_params
        params.permit(:name)
      end

      def serializer_class
        Api::V1::ProjectSerializer
      end
    end
  end
end
