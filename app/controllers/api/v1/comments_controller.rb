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
    if @comment.save
      render json: @comment, status: :created, location: api_v1_comment_url(@comment)
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
  end

  private

  def comment_params
    params.permit(:text, :attachment)
  end
end
