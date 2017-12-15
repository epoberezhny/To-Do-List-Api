class Api::V1::CommentsController < Api::V1::ApplicationController
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
    save_record(
      record: @comment, 
      location: -> { api_v1_project_task_comment_url(@project, @task, @comment) }
    ) do |comment|
      comment.reload
    end
  end

  def update
    update_record record: @comment, params: comment_params
  end

  def destroy
    @comment.destroy
  end

  private

  def comment_params
    params.permit(:text, :attachment)
  end
end
