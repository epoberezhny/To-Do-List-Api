# frozen_string_literal: true

RSpec.describe 'Tasks management' do
  let(:user)    { create(:user) }
  let(:headers) { { 'Authorization' => "Bearer #{access_token(user:)}" } }
  let(:project) { create(:project, user:) }

  before { login(user:) }

  describe 'GET api/v1/projects/:project_id/tasks' do
    describe 'success' do
      let!(:task) { create_list(:task, 3, project:) }

      before { get(api_v1_project_tasks_path(project), headers:) }

      include_examples 'match schema', 'api/v1/tasks/collection'

      it_behaves_like 'successful response'
    end

    describe 'unauthorized' do
      before { get(api_v1_project_tasks_path(project)) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'GET /api/v1/projects/:project_id/tasks/:id' do
    describe 'success' do
      let(:task) { create(:task, project:) }

      before { get(api_v1_project_task_path(project, task), headers:) }

      include_examples 'match schema', 'api/v1/tasks/single'

      it_behaves_like 'successful response'
    end

    describe 'forbidden' do
      let(:task)    { create(:task) }
      let(:project) { task.project }

      before { get(api_v1_project_task_path(project, task), headers:) }

      it_behaves_like 'forbidden response'
    end

    describe 'not found' do
      let(:task) { create(:task, project:) }

      before { get(api_v1_project_task_path(project, task.id + 1), headers:) }

      it_behaves_like 'not found response'
    end

    describe 'unauthorized' do
      before { get api_v1_project_task_path(project, 1) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'POST /api/v1/projects/:project_id/tasks' do
    describe 'created' do
      let(:params) { attributes_for(:task) }

      before { post(api_v1_project_tasks_path(project), headers:, params:) }

      include_examples 'match schema', 'api/v1/tasks/single'

      it_behaves_like 'created response' do
        let(:location) { api_v1_project_task_url(project, Task.last) }
      end
    end

    describe 'unprocessable' do
      let(:params) { attributes_for(:task, name: '') }

      before { post(api_v1_project_tasks_path(project), headers:, params:) }

      include_examples 'match schema', 'api/v1/errors'

      it_behaves_like 'unprocessable response'
    end

    describe 'unauthorized' do
      before { post(api_v1_project_tasks_path(project)) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'PATCH /api/v1/projects/:project_id/tasks/:id' do
    describe 'success' do
      let(:task)   { create(:task, project:) }
      let(:params) { attributes_for(:task, name: 'New name') }

      before { patch(api_v1_project_task_path(project, task), headers:, params:) }

      include_examples 'match schema', 'api/v1/tasks/single'

      it_behaves_like 'successful response'
    end

    describe 'unprocessable' do
      let(:task)   { create(:task, project:) }
      let(:params) { attributes_for(:task, name: '') }

      before { patch(api_v1_project_task_path(project, task), headers:, params:) }

      include_examples 'match schema', 'api/v1/errors'

      it_behaves_like 'unprocessable response'
    end

    describe 'forbidden' do
      let(:task)    { create(:task) }
      let(:project) { task.project }

      before { patch(api_v1_project_task_path(project, task), headers:) }

      it_behaves_like 'forbidden response'
    end

    describe 'not found' do
      let(:task) { create(:task, project:) }

      before { patch(api_v1_project_task_path(project, task.id + 1), headers:) }

      it_behaves_like 'not found response'
    end

    describe 'unauthorized' do
      before { patch(api_v1_project_task_path(project, 1)) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'DELETE /api/v1/projects/:project_id/tasks/:id' do
    describe 'success' do
      let(:task) { create(:task, project:) }

      before { delete(api_v1_project_task_path(project, task), headers:) }

      it_behaves_like 'successful response'
    end

    describe 'forbidden' do
      let(:task)    { create(:task) }
      let(:project) { task.project.id }

      before { delete(api_v1_project_task_path(project, task), headers:) }

      it_behaves_like 'forbidden response'
    end

    describe 'not found' do
      let(:task) { create(:task, project:) }

      before { delete(api_v1_project_task_path(project, task.id + 1), headers:) }

      it_behaves_like 'not found response'
    end

    describe 'unauthorized' do
      before { delete api_v1_project_task_path(project, 1) }

      it_behaves_like 'unauthorized response'
    end
  end
end
