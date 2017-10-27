Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      scope except: :show do
        resources :comments
        resources :tasks
        resources :projects
      end
    end
  end

  mount_devise_token_auth_for 'User', at: 'auth'
end
