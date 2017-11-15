class Api::V1::TasksController < Api::V1::ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :task, through: :project

  def index
    render json: @tasks
  end

  def show
    render json: @task
  end

  def create
    if @task.save
      render json: @task, status: :created, location: api_v1_project_task_url(@project, @task)
    else
      render json: @task.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
  end

  private

  def task_params
    params.permit(:name, :done, :priority, :deadline)
  end
end
