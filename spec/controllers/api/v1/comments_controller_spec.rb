# frozen_string_literal: true

RSpec.describe Api::V1::CommentsController do
  let(:user)    { create(:user) }
  let(:project) { create(:project, user:) }
  let(:task)    { create(:task, project:) }

  before do
    login(user:)
    request.headers.merge!('Authorization' => "Bearer #{access_token(user:)}")
  end

  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:comment, project_id: project.id, task_id: task.id) }

    it 'creates a new Comment' do
      expect do
        post :create, params: valid_attributes
      end.to change(Comment, :count).by(1)
    end
  end

  describe 'PATCH #update' do
    let(:comment)        { create(:comment, task:) }
    let(:new_attributes) do
      attributes_for(:comment, text: 'New name', project_id: project.id, task_id: task.id)
    end

    it 'updates the requested comment' do
      patch :update, params: { id: comment.to_param }.merge!(new_attributes)
      comment.reload
      expect(comment.text).to eq(new_attributes[:text])
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { create(:comment, task:) }

    it 'destroys the requested comment' do
      expect do
        delete :destroy,
               params: { id: comment.to_param, project_id: comment.task.project.id,
                         task_id: comment.task.id }
      end.to change(Comment, :count).by(-1)
    end
  end
end
