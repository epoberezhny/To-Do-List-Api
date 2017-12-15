class Api::V1::ProjectsController < Api::V1::ApplicationController
  load_and_authorize_resource

  def index
    render json: @projects
  end

  def show
    render json: @project
  end

  def create
    save_record record: @project, location: -> { api_v1_project_url(@project) }
  end

  def update
    update_record record: @project, params: project_params
  end

  def destroy
    @project.destroy
  end

  private

  def project_params
    params.permit(:name)
  end
end
