RSpec.describe 'Comments management', type: :request do
  let(:user)    { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let(:project) { create(:project, user: user) }
  let(:task)    { create(:task, project: project) }
  let(:params)  { { project_id: project.id, task_id: task.id } }

  describe 'GET api/v1/comments' do
    context 'success' do
      let!(:comment) { create_list(:comment, 3, task: task) }

      before { get(api_v1_comments_path, headers: headers, params: params) }

      include_examples 'match schema', 'comments'

      it_behaves_like 'successful response'
    end

    context 'unauthorized' do
      before { get(api_v1_comments_path) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'GET /api/v1/comments/:id' do
    context 'success' do
      let(:comment) { create(:comment, task: task) }

      before { get(api_v1_comment_path(comment), headers: headers, params: params) }

      include_examples 'match schema', 'comment'

      it_behaves_like 'successful response'
    end

    context 'forbidden' do
      let(:comment) { create(:comment) }
      let(:params)  { { project_id: comment.task.project.id, task_id: comment.task.id } }

      before { get(api_v1_comment_path(comment), headers: headers, params: params) }

      it_behaves_like 'forbidden response'
    end

    context 'not found' do
      let(:comment) { create(:comment, task: task) }

      before { get(api_v1_comment_path(comment.id + 1), headers: headers, params: params) }

      it_behaves_like 'not found response'
    end

    context 'unauthorized' do
      before { get api_v1_comment_path(1) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'POST /api/v1/comments' do
    context 'created' do
      let(:params) { attributes_for(:comment, project_id: project.id, task_id: task.id) }

      before { post(api_v1_comments_path, headers: headers, params: params) }

      include_examples 'match schema', 'comment'

      it_behaves_like 'created response' do
        let(:location) { api_v1_comment_url(Comment.last) }
      end
    end

    context 'unprocessable' do
      let(:params) { attributes_for(:comment, text: '', project_id: project.id, task_id: task.id) }

      before { post(api_v1_comments_path, headers: headers, params: params) }

      it_behaves_like 'unprocessable response'
    end

    context 'unauthorized' do
      before { post(api_v1_comments_path) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'PATCH /api/v1/project/:id' do
    context 'success' do
      let(:comment) { create(:comment, task: task) }
      let(:params)  { attributes_for(:comment, name: 'New name', project_id: project.id, task_id: task.id) }

      before { patch(api_v1_comment_path(comment), headers: headers, params: params) }

      include_examples 'match schema', 'comment'

      it_behaves_like 'successful response'
    end

    context 'unprocessable' do
      let(:comment) { create(:comment, task: task) }
      let(:params)  { attributes_for(:comment, text: '', project_id: project.id, task_id: task.id) }

      before { patch(api_v1_comment_path(comment), headers: headers, params: params) }

      it_behaves_like 'unprocessable response'
    end

    context 'forbidden' do
      let(:comment) { create(:comment) }
      let(:params)  { { project_id: comment.task.project.id, task_id: comment.task.id } }

      before { patch(api_v1_comment_path(comment), headers: headers, params: params) }

      it_behaves_like 'forbidden response'
    end

    context 'not found' do
      let(:comment) { create(:comment, task: task) }

      before { patch(api_v1_comment_path(comment.id + 1), headers: headers, params: params) }

      it_behaves_like 'not found response'
    end

    context 'unauthorized' do
      before { patch(api_v1_comment_path(1)) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'DELETE /api/v1/comments/:id' do
    context 'success' do
      let(:comment) { create(:comment, task: task) }

      before { delete(api_v1_comment_path(comment), headers: headers, params: params) }

      it_behaves_like 'successful response'
    end

    context 'forbidden' do
      let(:comment) { create(:comment) }
      let(:params) { { project_id: comment.task.project.id, task_id: comment.task.id } }

      before { delete(api_v1_comment_path(comment), headers: headers, params: params) }

      it_behaves_like 'forbidden response'
    end

    context 'not found' do
      let(:comment) { create(:comment, task: task) }

      before { delete(api_v1_comment_path(comment.id + 1), headers: headers, params: params) }

      it_behaves_like 'not found response'
    end

    context 'unauthorized' do
      before { delete api_v1_comment_path(1) }

      it_behaves_like 'unauthorized response'
    end
  end
end
