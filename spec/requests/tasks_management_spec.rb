# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Tasks management' do
  let(:user) { create(:user) }
  let(:Authorization) { "Bearer #{access_token(user:)}" }

  let(:project) { create(:project, user:) }
  let(:project_id) { project.id }

  before { login(user:) }

  def self.common_options
    tags 'Tasks'
    security [bearerAuth: []]
    consumes 'application/json'
    produces 'application/json'
    parameter name: :project_id, in: :path, type: :integer, required: true
  end

  def self.task_schema
    {
      type: :object,
      properties: {
        id: { type: :integer },
        name: { type: :string },
        done: { type: :boolean },
        priority: { type: :integer },
        deadline: {
          type: :string,
          nullable: true,
          format: 'date-time'
        },
        created_at: {
          type: :string,
          format: 'date-time'
        }
      },
      required: %i[id name done priority deadline created_at],
      additionalProperties: false
    }
  end

  def self.composed_schema
    {
      type: :object,
      properties: { data: task_schema },
      required: %i[data],
      additionalProperties: false
    }
  end

  path '/api/v1/projects/{project_id}/tasks' do
    post 'Create a task' do
      common_options
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: %i[name]
      }

      let(:params) { attributes_for(:task) }

      describe '201' do
        let(:location) { api_v1_project_task_url(project, Task.last) }

        include_examples 'created response'
      end

      it_behaves_like 'failed token auth'

      describe '403' do
        let(:project) { create(:project) }

        include_examples 'forbidden response'
      end

      describe '422' do
        let(:params) { attributes_for(:task, name: '') }

        include_examples 'unprocessable response'
      end
    end

    get 'List of tasks' do
      common_options

      def self.composed_schema
        {
          type: :object,
          properties: {
            data: { type: :array, items: task_schema }
          },
          required: %i[data],
          additionalProperties: false
        }
      end

      describe '200' do
        before { create_list(:task, 2, project:) }

        include_examples 'success response'
      end

      it_behaves_like 'failed token auth'

      describe '403' do
        let(:project) { create(:project) }

        include_examples 'forbidden response'
      end
    end
  end

  path '/api/v1/projects/{project_id}/tasks/{id}' do
    let(:task) { create(:task, project:) }
    let(:id) { task.id }

    def self.common_options
      super
      parameter name: :id, in: :path, type: :integer, required: true
    end

    shared_examples 'not found responses' do
      describe '404' do
        context 'when task not found' do
          let(:id) { task.id + 1 }

          include_examples 'not found response'
        end

        context 'when project not found' do
          let(:project_id) { project.id + 1 }

          include_examples 'not found response'
        end
      end
    end

    shared_examples 'forbidden responses' do
      describe '403' do
        let(:project) { create(:project) }

        include_examples 'forbidden response'
      end
    end

    get 'Single task' do
      common_options

      describe '200' do
        include_examples 'success response'
      end

      it_behaves_like 'failed token auth'

      include_examples 'forbidden responses'

      include_examples 'not found responses'
    end

    delete 'Delete task' do
      common_options

      describe '204' do
        include_examples 'no content response'
      end

      it_behaves_like 'failed token auth'

      include_examples 'forbidden responses'

      include_examples 'not found responses'
    end

    patch 'Update task' do
      common_options
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          done: { type: :boolean },
          priority: { type: :integer },
          deadline: { type: :string, format: 'date-time' }
        }
      }

      let(:params) { attributes_for(:task, :full) }

      describe '200' do
        include_examples 'success response'
      end

      it_behaves_like 'failed token auth'

      include_examples 'forbidden responses'

      include_examples 'not found responses'

      describe '422' do
        let(:params) { attributes_for(:task, name: '') }

        include_examples 'unprocessable response'
      end
    end
  end
end
