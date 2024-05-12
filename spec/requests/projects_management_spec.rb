# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Projects management' do
  let(:user) { create(:user) }
  let(:Authorization) { "Bearer #{access_token(user:)}" }

  before { login(user:) }

  def self.common_options
    tags 'Projects'
    security [bearerAuth: []]
    consumes 'application/json'
    produces 'application/json'
  end

  def self.project_schema
    {
      type: :object,
      properties: {
        id: { type: :integer },
        name: { type: :string },
        created_at: { type: :string, format: 'date-time' }
      },
      required: %i[id name created_at],
      additionalProperties: false
    }
  end

  def self.composed_schema
    {
      type: :object,
      properties: { data: project_schema },
      required: %i[data],
      additionalProperties: false
    }
  end

  path '/api/v1/projects' do
    post 'Create a project' do
      common_options
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: %i[name]
      }

      let(:params) { attributes_for(:project) }

      describe '201' do
        let(:location) { api_v1_project_url(Project.last) }

        include_examples 'created response'
      end

      it_behaves_like 'failed token auth'

      describe '422' do
        let(:params) { attributes_for(:project, name: '') }

        include_examples 'unprocessable response'
      end
    end

    get 'List of projects' do
      common_options

      def self.composed_schema
        {
          type: :object,
          properties: {
            data: { type: :array, items: project_schema }
          },
          required: %i[data],
          additionalProperties: false
        }
      end

      describe '200' do
        before { create_list(:project, 2, user:) }

        include_examples 'success response'
      end

      it_behaves_like 'failed token auth'
    end
  end

  path '/api/v1/projects/{id}' do
    let(:project) { create(:project, user:) }
    let(:id) { project.id }

    def self.common_options
      super
      parameter name: :id, in: :path, type: :integer, required: true
    end

    shared_examples 'not found responses' do
      describe '404' do
        let(:id) { project.id + 1 }

        include_examples 'not found response'
      end
    end

    shared_examples 'forbidden responses' do
      describe '403' do
        let(:project) { create(:project) }

        include_examples 'forbidden response'
      end
    end

    get 'Single project' do
      common_options

      describe '200' do
        include_examples 'success response'
      end

      it_behaves_like 'failed token auth'

      include_examples 'forbidden responses'

      include_examples 'not found responses'
    end

    delete 'Delete project' do
      common_options

      describe '204' do
        include_examples 'no content response'
      end

      it_behaves_like 'failed token auth'

      include_examples 'forbidden responses'

      include_examples 'not found responses'
    end

    patch 'Update project' do
      common_options
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        }
      }

      let(:params) { attributes_for(:project) }

      describe '200' do
        include_examples 'success response'
      end

      it_behaves_like 'failed token auth'

      include_examples 'forbidden responses'

      include_examples 'not found responses'

      describe '422' do
        let(:params) { attributes_for(:project, name: '') }

        include_examples 'unprocessable response'
      end
    end
  end
end
