# frozen_string_literal: true

RSpec.describe 'Projects management' do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => "Bearer #{access_token(user:)}" } }

  before { login(user:) }

  describe 'GET api/v1/projects' do
    describe 'success' do
      let!(:projects) { create_list(:project, 3, user:) }

      before { get(api_v1_projects_path, headers:) }

      include_examples 'match schema', 'api/v1/projects/collection'

      it_behaves_like 'successful response'
    end

    describe 'unauthorized' do
      before { get(api_v1_projects_path) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'GET /api/v1/projects/:id' do
    describe 'success' do
      let(:project) { create(:project, user:) }

      before { get(api_v1_project_path(project), headers:) }

      include_examples 'match schema', 'api/v1/projects/single'

      it_behaves_like 'successful response'
    end

    describe 'forbidden' do
      let(:project) { create(:project) }

      before { get(api_v1_project_path(project), headers:) }

      it_behaves_like 'forbidden response'
    end

    describe 'not found' do
      let(:project) { create(:project, user:) }

      before { get(api_v1_project_path(project.id + 1), headers:) }

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

      before { post(api_v1_projects_path, headers:, params:) }

      include_examples 'match schema', 'api/v1/projects/single'

      it_behaves_like 'created response' do
        let(:location) { api_v1_project_url(Project.last) }
      end
    end

    describe 'unprocessable' do
      let(:params) { attributes_for(:project, name: '') }

      before { post(api_v1_projects_path, headers:, params:) }

      include_examples 'match schema', 'api/v1/errors'

      it_behaves_like 'unprocessable response'
    end

    describe 'unauthorized' do
      before { post(api_v1_projects_path) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'PATCH /api/v1/project/:id' do
    describe 'success' do
      let(:project) { create(:project, user:) }
      let(:params)  { attributes_for(:project, name: 'New name') }

      before { patch(api_v1_project_path(project), headers:, params:) }

      include_examples 'match schema', 'api/v1/projects/single'

      it_behaves_like 'successful response'
    end

    describe 'unprocessable' do
      let(:project) { create(:project, user:) }
      let(:params)  { attributes_for(:project, name: '') }

      before { patch(api_v1_project_path(project), headers:, params:) }

      include_examples 'match schema', 'api/v1/errors'

      it_behaves_like 'unprocessable response'
    end

    describe 'forbidden' do
      let(:project) { create(:project) }

      before { patch(api_v1_project_path(project), headers:) }

      it_behaves_like 'forbidden response'
    end

    describe 'not found' do
      let(:project) { create(:project, user:) }

      before { patch(api_v1_project_path(project.id + 1), headers:) }

      it_behaves_like 'not found response'
    end

    describe 'unauthorized' do
      before { patch(api_v1_project_path(1)) }

      it_behaves_like 'unauthorized response'
    end
  end

  describe 'DELETE /api/v1/projects/:id' do
    describe 'success' do
      let(:project) { create(:project, user:) }

      before { delete(api_v1_project_path(project), headers:) }

      it_behaves_like 'successful response'
    end

    describe 'forbidden' do
      let(:project) { create(:project) }

      before { delete(api_v1_project_path(project), headers:) }

      it_behaves_like 'forbidden response'
    end

    describe 'not found' do
      let(:project) { create(:project, user:) }

      before { delete(api_v1_project_path(project.id + 1), headers:) }

      it_behaves_like 'not found response'
    end

    describe 'unauthorized' do
      before { delete api_v1_project_path(1) }

      it_behaves_like 'unauthorized response'
    end
  end
end
