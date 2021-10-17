Rails.application.routes.draw do
  root to: 'application#index'
  get '/auth/:provider/callback', to: 'application#spotify_auth_callback'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
