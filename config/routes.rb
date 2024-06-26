# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      resource :attachment, only: [] do
        post 'upload'
      end

      resources :projects do
        resources :tasks do
          resources :comments
        end
      end
    end
  end
end
