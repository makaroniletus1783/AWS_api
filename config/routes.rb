Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: 'top#home'

  scope :v1 do
    post "stocks", to: "stocks#create"
    get "stocks/:name", to: "stocks#show"
    get "stock/new", to: "stocks#new"
  end
end
