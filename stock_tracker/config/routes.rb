Rails.application.routes.draw do
  resources :user_stocks, only: [:create, :destroy]
  devise_for :users
  root "home#index"
  get "my_portfolio", to: "users#my_portfolio"
  get "search_stock", to: "stocks#search"
  get "my_friends", to: "users#my_friends"
  post "my_friends/:id", to: "users#follow", as: :follow
  delete "my_friends/:id", to: "users#unfriend", as: :unfriend
  get "search_friend", to: "users#search"
end
