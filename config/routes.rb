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

  mount_devise_token_auth_for 'User', at: 'auth'
end
