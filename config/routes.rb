# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :projects do
        resources :tasks do
          resources :comments
        end
      end
    end
  end
end
