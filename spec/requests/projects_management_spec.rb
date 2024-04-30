# frozen_string_literal: true

RSpec.describe 'Projects management' do
  let(:user)    { create(:user) }
  let(:headers) { user.create_new_auth_token }

  describe 'GET api/v1/projects' do
    describe 'success' do
      let!(:projects) { create_list(:project, 3, user: user) }

      before { get(api_v1_projects_path, headers: headers) }

      include_examples 'match schema', 'projects'

      it_behaves_like 'successful response'
    end

    describe 'unauthorized' do
      before { get(api_v1_projects_path) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'GET /api/v1/projects/:id' do
    describe 'success' do
      let(:project) { create(:project, user: user) }

      before { get(api_v1_project_path(project), headers: headers) }

      include_examples 'match schema', 'project'

      it_behaves_like 'successful response'
    end

    describe 'forbidden' do
      let(:project) { create(:project) }

      before { get(api_v1_project_path(project), headers: headers) }

      it_behaves_like 'forbidden response'
    end

    describe 'not found' do
      let(:project) { create(:project, user: user) }

      before { get(api_v1_project_path(project.id + 1), headers: headers) }

      it_behaves_like 'not found response'
    end

    describe 'unauthorized' do
      before { get api_v1_project_path(1) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'POST /api/v1/projects' do
    describe 'created' do
      let(:params) { attributes_for(:project) }

      before { post(api_v1_projects_path, headers: headers, params: params) }

      include_examples 'match schema', 'project'

      it_behaves_like 'created response' do
        let(:location) { api_v1_project_url(Project.last) }
      end
    end

    describe 'unprocessable' do
      let(:params) { attributes_for(:project, name: '') }

      before { post(api_v1_projects_path, headers: headers, params: params) }

      it_behaves_like 'unprocessable response'
    end

    describe 'unauthorized' do
      before { post(api_v1_projects_path) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'PATCH /api/v1/project/:id' do
    describe 'success' do
      let(:project) { create(:project, user: user) }
      let(:params)  { attributes_for(:project, name: 'New name') }

      before { patch(api_v1_project_path(project), headers: headers, params: params) }

      include_examples 'match schema', 'project'

      it_behaves_like 'successful response'
    end

    describe 'unprocessable' do
      let(:project) { create(:project, user: user) }
      let(:params)  { attributes_for(:project, name: '') }

      before { patch(api_v1_project_path(project), headers: headers, params: params) }

      it_behaves_like 'unprocessable response'
    end

    describe 'forbidden' do
      let(:project) { create(:project) }

      before { patch(api_v1_project_path(project), headers: headers) }

      it_behaves_like 'forbidden response'
    end

    describe 'not found' do
      let(:project) { create(:project, user: user) }

      before { patch(api_v1_project_path(project.id + 1), headers: headers) }

      it_behaves_like 'not found response'
    end

    describe 'unauthorized' do
      before { patch(api_v1_project_path(1)) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'DELETE /api/v1/projects/:id' do
    describe 'success' do
      let(:project) { create(:project, user: user) }

      before { delete(api_v1_project_path(project), headers: headers) }

      it_behaves_like 'successful response'
    end

    describe 'forbidden' do
      let(:project) { create(:project) }

      before { delete(api_v1_project_path(project), headers: headers) }

      it_behaves_like 'forbidden response'
    end

    describe 'not found' do
      let(:project) { create(:project, user: user) }

      before { delete(api_v1_project_path(project.id + 1), headers: headers) }

      it_behaves_like 'not found response'
    end

    describe 'unauthorized' do
      before { delete api_v1_project_path(1) }

      it_behaves_like 'unauthorized response'
    end
  end
end
