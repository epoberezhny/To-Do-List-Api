RSpec.describe 'Tasks management', type: :request do
  let(:user)    { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let(:project) { create(:project, user: user) }
  let(:params)  { { project_id: project.id } }

  describe 'GET api/v1/tasks' do
    context 'success' do
      let!(:task) { create_list(:task, 3, project: project) }

      before { get(api_v1_tasks_path, headers: headers, params: params) }

      include_examples 'match schema', 'tasks'

      it_behaves_like 'successful response'
    end

    context 'unauthorized' do
      before { get(api_v1_tasks_path) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'GET /api/v1/tasks/:id' do
    context 'success' do
      let(:task) { create(:task, project: project) }

      before { get(api_v1_task_path(task), headers: headers, params: params) }

      include_examples 'match schema', 'task'

      it_behaves_like 'successful response'
    end

    context 'forbidden' do
      let(:task)   { create(:task) }
      let(:params) { { project_id: task.project.id } }

      before { get(api_v1_task_path(task), headers: headers, params: params) }

      it_behaves_like 'forbidden response'
    end

    context 'not found' do
      let(:task) { create(:task, project: project) }

      before { get(api_v1_task_path(task.id + 1), headers: headers, params: params) }

      it_behaves_like 'not found response'
    end

    context 'unauthorized' do
      before { get api_v1_task_path(1) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'POST /api/v1/tasks' do
    context 'created' do
      let(:params) { attributes_for(:task, project_id: project.id) }

      before { post(api_v1_tasks_path, headers: headers, params: params) }

      include_examples 'match schema', 'task'

      it_behaves_like 'created response' do
        let(:location) { api_v1_task_url(Task.last) }
      end
    end

    context 'unprocessable' do
      let(:params) { attributes_for(:task, name: '', project_id: project.id) }

      before { post(api_v1_tasks_path, headers: headers, params: params) }

      it_behaves_like 'unprocessable response'
    end

    context 'unauthorized' do
      before { post(api_v1_tasks_path) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'PATCH /api/v1/project/:id' do
    context 'success' do
      let(:task)   { create(:task, project: project) }
      let(:params) { attributes_for(:task, name: 'New name', project_id: project.id) }

      before { patch(api_v1_task_path(task), headers: headers, params: params) }

      include_examples 'match schema', 'task'

      it_behaves_like 'successful response'
    end

    context 'unprocessable' do
      let(:task)   { create(:task, project: project) }
      let(:params) { attributes_for(:task, name: '', project_id: project.id) }

      before { patch(api_v1_task_path(task), headers: headers, params: params) }

      it_behaves_like 'unprocessable response'
    end

    context 'forbidden' do
      let(:task)   { create(:task) }
      let(:params) { { project_id: task.project.id } }

      before { patch(api_v1_task_path(task), headers: headers, params: params) }

      it_behaves_like 'forbidden response'
    end

    context 'not found' do
      let(:task) { create(:task, project: project) }

      before { patch(api_v1_task_path(task.id + 1), headers: headers, params: params) }

      it_behaves_like 'not found response'
    end

    context 'unauthorized' do
      before { patch(api_v1_task_path(1)) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'DELETE /api/v1/tasks/:id' do
    context 'success' do
      let(:task) { create(:task, project: project) }

      before { delete(api_v1_task_path(task), headers: headers, params: params) }

      it_behaves_like 'successful response'
    end

    context 'forbidden' do
      let(:task)   { create(:task) }
      let(:params) { { project_id: task.project.id } }

      before { delete(api_v1_task_path(task), headers: headers, params: params) }

      it_behaves_like 'forbidden response'
    end

    context 'not found' do
      let(:task) { create(:task, project: project) }

      before { delete(api_v1_task_path(task.id + 1), headers: headers, params: params) }

      it_behaves_like 'not found response'
    end

    context 'unauthorized' do
      before { delete api_v1_task_path(1) }

      it_behaves_like 'unauthorized response'
    end
  end
end
