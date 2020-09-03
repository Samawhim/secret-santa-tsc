Rails.application.routes.draw do
  resources :events, only: [:create, :show]
  root to: 'events#new'
end