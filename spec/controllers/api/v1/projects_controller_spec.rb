# frozen_string_literal: true

RSpec.describe Api::V1::ProjectsController do
  let(:user) { create(:user) }

  before do
    login(user:)
    request.headers.merge!('Authorization' => "Bearer #{access_token(user:)}")
  end

  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:project) }

    it 'creates a new Project' do
      expect do
        post :create, params: valid_attributes
      end.to change(Project, :count).by(1)
    end
  end

  describe 'PATCH #update' do
    let(:project)        { create(:project, user:) }
    let(:new_attributes) { attributes_for(:project, name: 'New name') }

    it 'updates the requested project' do
      patch :update, params: { id: project.to_param }.merge!(new_attributes)
      project.reload
      expect(project.name).to eq(new_attributes[:name])
    end
  end

  describe 'DELETE #destroy' do
    let!(:project) { create(:project, user:) }

    it 'destroys the requested project' do
      expect do
        delete :destroy, params: { id: project.to_param }
      end.to change(Project, :count).by(-1)
    end
  end
end
