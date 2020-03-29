Rails.application.routes.draw do
  
  resources :gtrends, only: [:index, :create, :destroy], path: '/'
  
end
