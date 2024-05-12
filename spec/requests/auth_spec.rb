# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Auth' do
  let(:password) { 'password' }

  def self.common_options
    tags 'Auth'
    consumes 'application/json'
    produces 'application/json'
  end

  path '/auth/accounts' do
    post 'Create an account' do
      common_options
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: %i[email password]
      }

      let(:params) { attributes_for(:user, password:).merge(password_confirmation: password) }

      def self.tokens_schema
        {
          type: :object,
          properties: {
            access_token: { type: :string },
            refresh_token: { type: :string }
          },
          required: %i[access_token refresh_token],
          additionalProperties: false
        }
      end

      def self.composed_schema
        {
          type: :object,
          properties: { data: tokens_schema },
          required: %i[data],
          additionalProperties: false
        }
      end

      describe '200' do
        include_examples 'success response'
      end

      describe '422' do
        let(:params) { attributes_for(:user) }

        include_examples 'unprocessable response'
      end
    end
  end

  path '/auth/login' do
    let!(:user) { create(:user, password:) }

    post 'Retrieve access and refresh tokens' do
      common_options
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %i[email password]
      }

      let(:params) { { email: user.email, password: } }

      def self.tokens_schema
        {
          type: :object,
          properties: {
            access_token: { type: :string },
            refresh_token: { type: :string }
          },
          required: %i[access_token refresh_token],
          additionalProperties: false
        }
      end

      def self.composed_schema
        {
          type: :object,
          properties: { data: tokens_schema },
          required: %i[data],
          additionalProperties: false
        }
      end

      describe '200' do
        include_examples 'success response'
      end

      describe '401' do
        let(:params) { attributes_for(:user, password: '') }

        include_examples 'unauthorized response'
      end
    end
  end

  path '/auth/logout' do
    let(:user) { create(:user, password:) }
    let(:Authorization) { "Bearer #{access_token(user:)}" }

    before { login(user:) }

    post 'Logout' do
      common_options
      security [bearerAuth: []]
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          refresh_token: { type: :string }
        }
      }

      let!(:params) { { refresh_token: refresh_token(user:) } }

      describe '204' do
        include_examples 'no content response'
      end
    end
  end

  path '/auth/refresh' do
    let(:user) { create(:user, password:) }
    let(:Authorization) { "Bearer #{access_token(user:)}" }

    before { login(user:) }

    post 'Refresh tokens' do
      common_options
      security [bearerAuth: []]
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          refresh_token: { type: :string }
        }
      }

      let!(:params) { { refresh_token: refresh_token(user:) } }

      def self.tokens_schema
        {
          type: :object,
          properties: {
            access_token: { type: :string },
            refresh_token: { type: :string }
          },
          required: %i[access_token refresh_token],
          additionalProperties: false
        }
      end

      def self.composed_schema
        {
          type: :object,
          properties: { data: tokens_schema },
          required: %i[data],
          additionalProperties: false
        }
      end

      describe '200' do
        include_examples 'success response'
      end

      describe '400' do
        context 'without access token' do
          let(:Authorization) { '' }

          include_examples 'bad request response'
        end

        context 'without refresh token' do
          let(:params) { {} }

          include_examples 'bad request response'
        end
      end
    end
  end
end
