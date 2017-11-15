class Api::V1::ProjectsController < Api::V1::ApplicationController
  load_and_authorize_resource

  def index
    render json: @projects
  end

  def show
    render json: @project
  end

  def create
    if @project.save
      render json: @project, status: :created, location: api_v1_project_url(@project)
    else
      render json: @project.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
  end

  private

  def project_params
    params.permit(:name)
  end
end
