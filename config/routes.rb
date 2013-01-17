Bookanalytics::Application.routes.draw do
  resources :purchases

  root to: 'purchases#index'
end
