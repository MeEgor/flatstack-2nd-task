Rails.application.routes.draw do
  # пользователи
  resources :users, :only => [:create, :show, :update, :destroy]

  # сесии
  resources :sessions, :only => [:create]
  get '/sign_in' => 'sessions#new', as: 'sign_in'
  get '/current_user' => 'sessions#show_current_user', as: 'current_user'
  delete '/sign_out' => 'sessions#destroy', as: 'sign_out'

  # Шаблоны
  get "/templates/*path" => 'templates#index'

  # Корень сайта
  root 'site#index'

end
