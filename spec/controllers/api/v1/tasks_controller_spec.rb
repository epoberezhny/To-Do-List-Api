# frozen_string_literal: true

RSpec.describe Api::V1::TasksController do
  let(:user)    { create(:user) }
  let(:project) { create(:project, user: user) }

  before { request.headers.merge!(user.create_new_auth_token) }

  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:task, project_id: project.id) }

    it 'creates a new Task' do
      expect do
        post :create, params: valid_attributes
      end.to change(Task, :count).by(1)
    end
  end

  describe 'PATCH #update' do
    let(:task)           { create(:task, project: project) }
    let(:new_attributes) { attributes_for(:task, name: 'New name', project_id: project.id) }

    it 'updates the requested task' do
      patch :update, params: { id: task.to_param }.merge!(new_attributes)
      task.reload
      expect(task.name).to eq(new_attributes[:name])
    end
  end

  describe 'DELETE #destroy' do
    let!(:task) { create(:task, project: project) }

    it 'destroys the requested task' do
      expect do
        delete :destroy, params: { id: task.to_param, project_id: task.project.id }
      end.to change(Task, :count).by(-1)
    end
  end
end
