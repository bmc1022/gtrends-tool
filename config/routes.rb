Rails.application.routes.draw do
  
  root 'gtrends#index'
  
  resources :gtrends, only: [:create, :destroy]
  
end
