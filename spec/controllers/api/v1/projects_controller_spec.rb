RSpec.describe Api::V1::ProjectsController, type: :controller do
  let(:user) { create(:user) }

  before { request.headers.merge!(user.create_new_auth_token) }

  describe "POST #create" do
    let(:valid_attributes) { attributes_for(:project) }

    it "creates a new Project" do
      expect {
        post :create, params: valid_attributes
      }.to change(Project, :count).by(1)
    end
  end

  describe "PATCH #update" do
    let(:project)        { create(:project, user: user) }
    let(:new_attributes) { attributes_for(:project, name: 'New name') }

    it "updates the requested project" do
      patch :update, params: { id: project.to_param }.merge!(new_attributes)
      project.reload
      expect(project.name).to eq(new_attributes[:name])
    end
  end

  describe "DELETE #destroy" do
    let!(:project) { create(:project, user: user) }

    it "destroys the requested project" do
      expect {
        delete :destroy, params: { id: project.to_param }
      }.to change(Project, :count).by(-1)
    end
  end
end
