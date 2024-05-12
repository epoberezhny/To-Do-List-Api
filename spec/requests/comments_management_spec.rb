# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Comments management' do
  let(:user) { create(:user) }
  let(:Authorization) { "Bearer #{access_token(user:)}" }

  let(:project) { create(:project, user:) }
  let(:task) { create(:task, project:) }
  let(:project_id) { project.id }
  let(:task_id) { task.id }

  before { login(user:) }

  def self.common_options
    tags 'Comments'
    security [bearerAuth: []]
    consumes 'application/json'
    produces 'application/json'
    parameter name: :project_id, in: :path, type: :integer, required: true
    parameter name: :task_id, in: :path, type: :integer, required: true
  end

  def self.comment_schema
    {
      type: :object,
      properties: {
        id: { type: :integer },
        text: { type: :string },
        attachment_url: { type: :string, nullable: true },
        created_at: { type: :string, format: 'date-time' }
      },
      required: %i[id text attachment_url created_at],
      additionalProperties: false
    }
  end

  def self.composed_schema
    {
      type: :object,
      properties: { data: comment_schema },
      required: %i[data],
      additionalProperties: false
    }
  end

  path '/api/v1/projects/{project_id}/tasks/{task_id}/comments' do
    post 'Create a comment' do
      common_options
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          text: { type: :string },
          attachment: { type: :object }
        },
        required: %i[name]
      }

      let(:params) { attributes_for(:comment) }

      describe '201' do
        let(:location) { api_v1_project_task_comment_url(project, task, Comment.last) }

        include_examples 'created response'
      end

      it_behaves_like 'failed token auth'

      describe '403' do
        let(:project) { create(:project) }

        include_examples 'forbidden response'
      end

      describe '422' do
        let(:params) { attributes_for(:comment, text: '') }

        include_examples 'unprocessable response'
      end
    end

    get 'List of comments' do
      common_options

      def self.composed_schema
        {
          type: :object,
          properties: {
            data: { type: :array, items: comment_schema }
          },
          required: %i[data],
          additionalProperties: false
        }
      end

      describe '200' do
        before { create_list(:comment, 2, task:) }

        include_examples 'success response'
      end

      it_behaves_like 'failed token auth'

      describe '403' do
        let(:project) { create(:project) }

        include_examples 'forbidden response'
      end
    end
  end

  path '/api/v1/projects/{project_id}/tasks/{task_id}/comments/{id}' do
    let(:comment) { create(:comment, task:) }
    let(:id) { comment.id }

    def self.common_options
      super
      parameter name: :id, in: :path, type: :integer, required: true
    end

    shared_examples 'not found responses' do
      describe '404' do
        context 'when comment not found' do
          let(:id) { comment.id + 1 }

          include_examples 'not found response'
        end

        context 'when task not found' do
          let(:task_id) { task.id + 1 }

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

    get 'Single comment' do
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
          text: { type: :string },
          attachment: { type: :object }
        }
      }

      let(:params) { attributes_for(:comment) }

      describe '200' do
        include_examples 'success response'
      end

      it_behaves_like 'failed token auth'

      include_examples 'forbidden responses'

      include_examples 'not found responses'

      describe '422' do
        let(:params) { attributes_for(:comment, text: '') }

        include_examples 'unprocessable response'
      end
    end
  end
end
