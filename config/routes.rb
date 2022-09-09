Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: 'top#home'
  get "secret", to: "secret#digest"

  scope :v1 do
    post "stocks", to: "stocks#create"
    get "stocks", to: "stocks#index"
    get "stocks/:name", to: "stocks#show", as: :stock

  end
end
