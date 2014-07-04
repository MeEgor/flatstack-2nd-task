Rails.application.routes.draw do
  # события
  resources :events, :only => [:create, :update, :show, :destroy]
  get '/events/day/:date' => 'events#day'
  get '/events/month/:date' => 'events#month'

  # пользователи
  resources :users, :only => [:create, :show, :update, :destroy]
  post '/users/:id/send_confirmation_email' => 'users#send_verify_email'
  post '/users/confirm_email/:token' => 'users#confirm_email'
  post '/users/:id/change_password' => 'users#change_password'
  post '/users/:id/create_password' => 'users#create_password'

  # сесии
  resources :sessions, :only => [:create]
  get '/sign_in' => 'sessions#new', as: 'sign_in'
  get '/current_user' => 'sessions#show_current_user', as: 'current_user'
  delete '/sign_out' => 'sessions#destroy', as: 'sign_out'
  get '/vk-auth' => 'sessions#vk_auth'

  # Шаблоны
  get "/templates/*path" => 'templates#index'

  # Корень сайта
  root 'site#index'

end
