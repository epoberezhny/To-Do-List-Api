# frozen_string_literal: true

RSpec.describe 'Comments management' do
  let(:user)    { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let(:project) { create(:project, user: user) }
  let(:task)    { create(:task, project: project) }

  describe 'GET api/v1/projects/:project_id/tasks/:task_id/comments' do
    describe 'success' do
      let!(:comment) { create_list(:comment, 3, task: task) }

      before { get(api_v1_project_task_comments_path(project, task), headers: headers) }

      include_examples 'match schema', 'comments'

      it_behaves_like 'successful response'
    end

    describe 'unauthorized' do
      before { get(api_v1_project_task_comments_path(project, task)) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'GET /api/v1/projects/:project_id/tasks/:task_id/comments/:id' do
    describe 'success' do
      let(:comment) { create(:comment, task: task) }

      before { get(api_v1_project_task_comment_path(project, task, comment), headers: headers) }

      include_examples 'match schema', 'comment'

      it_behaves_like 'successful response'
    end

    describe 'forbidden' do
      let(:comment) { create(:comment) }
      let(:task)    { comment.task }
      let(:project) { task.project }

      before { get(api_v1_project_task_comment_path(project, task, comment), headers: headers) }

      it_behaves_like 'forbidden response'
    end

    describe 'not found' do
      let(:comment) { create(:comment, task: task) }

      before do
        get(api_v1_project_task_comment_path(project, task, comment.id + 1), headers: headers)
      end

      it_behaves_like 'not found response'
    end

    describe 'unauthorized' do
      before { get api_v1_project_task_comment_path(project, task, 1) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'POST /api/v1/projects/:project_id/tasks/:task_id/comments' do
    describe 'created' do
      let(:params) { attributes_for(:comment) }

      before do
        post(api_v1_project_task_comments_path(project, task), headers: headers, params: params)
      end

      include_examples 'match schema', 'comment'

      it_behaves_like 'created response' do
        let(:location) { api_v1_project_task_comment_url(project, task, Comment.last) }
      end
    end

    describe 'unprocessable' do
      let(:params) { attributes_for(:comment, text: '') }

      before do
        post(api_v1_project_task_comments_path(project, task), headers: headers, params: params)
      end

      it_behaves_like 'unprocessable response'
    end

    describe 'unauthorized' do
      before { post(api_v1_project_task_comments_path(project, task)) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'PATCH /api/v1/projects/:project_id/tasks/:task_id/cooments/:id' do
    describe 'success' do
      let(:comment) { create(:comment, task: task) }
      let(:params)  { attributes_for(:comment, name: 'New name') }

      before do
        patch(api_v1_project_task_comment_path(project, task, comment), headers: headers,
                                                                        params: params)
      end

      include_examples 'match schema', 'comment'

      it_behaves_like 'successful response'
    end

    describe 'unprocessable' do
      let(:comment) { create(:comment, task: task) }
      let(:params)  { attributes_for(:comment, text: '') }

      before do
        patch(api_v1_project_task_comment_path(project, task, comment), headers: headers,
                                                                        params: params)
      end

      it_behaves_like 'unprocessable response'
    end

    describe 'forbidden' do
      let(:comment) { create(:comment) }
      let(:task)    { comment.task }
      let(:project) { task.project }

      before { patch(api_v1_project_task_comment_path(project, task, comment), headers: headers) }

      it_behaves_like 'forbidden response'
    end

    describe 'not found' do
      let(:comment) { create(:comment, task: task) }

      before do
        patch(api_v1_project_task_comment_path(project, task, comment.id + 1), headers: headers)
      end

      it_behaves_like 'not found response'
    end

    describe 'unauthorized' do
      before { patch(api_v1_project_task_comment_path(project, task, 1)) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'DELETE /api/v1/projects/:project_id/tasks/:task_id/comments/:id' do
    describe 'success' do
      let(:comment) { create(:comment, task: task) }

      before { delete(api_v1_project_task_comment_path(project, task, comment), headers: headers) }

      it_behaves_like 'successful response'
    end

    describe 'forbidden' do
      let(:comment) { create(:comment) }
      let(:task)    { comment.task }
      let(:project) { task.project }

      before { delete(api_v1_project_task_comment_path(project, task, comment), headers: headers) }

      it_behaves_like 'forbidden response'
    end

    describe 'not found' do
      let(:comment) { create(:comment, task: task) }

      before do
        delete(api_v1_project_task_comment_path(project, task, comment.id + 1), headers: headers)
      end

      it_behaves_like 'not found response'
    end

    describe 'unauthorized' do
      before { delete api_v1_project_task_comment_path(project, task, 1) }

      it_behaves_like 'unauthorized response'
    end
  end
end
