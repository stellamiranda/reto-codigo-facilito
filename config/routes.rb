Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'tasks#index'
  resources :tasks

  namespace :api do
    namespace :v1 do
      resources :tasks, only: [:index, :show, :create, :destroy] do
        get :image, on: :member
      end
    end
  end

end
