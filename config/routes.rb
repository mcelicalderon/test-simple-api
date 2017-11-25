Rails.application.routes.draw do
  resources :users
  resources :locations
  resources :events do
    post :publish
    post :unpublish
  end
end
