Rails.application.routes.draw do
  root "projects#index"

  resources :projects do
    resources :tasks do
      put :change_status
    end
  end
end
