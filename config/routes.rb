CatarseDineromail::Engine.routes.draw do
  namespace :payment do
    resources :dineromail, only: [] do
      member do
        get :pay
        get :success
        get :error
        get :notifications
      end
    end
  end
end
