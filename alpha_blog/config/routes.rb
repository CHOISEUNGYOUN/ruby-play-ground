Rails.application.routes.draw do
  resources :articles
  root "pages#home"
  get "about", to: "pages#about"
  resources :articles
  get "signup", to: "users#new"
  resources :users, except: [:new]
end
