RSpec.describe Api::V1::CommentsController, type: :controller do
  let(:user)    { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task)    { create(:task, project: project) }
  
  before { request.headers.merge!(user.create_new_auth_token) }

  describe "POST #create" do
    let(:valid_attributes) { attributes_for(:comment, project_id: project.id, task_id: task.id) }

    it "creates a new Comment" do
      expect {
        post :create, params: valid_attributes
      }.to change(Comment, :count).by(1)
    end
  end

  describe "PATCH #update" do
    let(:comment)        { create(:comment, task: task) }
    let(:new_attributes) { attributes_for(:comment, text: 'New name', project_id: project.id, task_id: task.id) }

    it "updates the requested comment" do
      patch :update, params: { id: comment.to_param }.merge!(new_attributes)
      comment.reload
      expect(comment.text).to eq(new_attributes[:text])
    end
  end

  describe "DELETE #destroy" do
    let!(:comment) { create(:comment, task: task) }

    it "destroys the requested comment" do
      expect {
        delete :destroy, params: { id: comment.to_param, project_id: comment.task.project.id, task_id: comment.task.id }
      }.to change(Comment, :count).by(-1)
    end
  end
end
