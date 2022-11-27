Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"
  get 'distance', to: 'pages#distance'
  get 'calculated', to: 'pages#calculated'
end
