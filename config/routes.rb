Rails.application.routes.draw do
  
  root 'gtrends#index'
  
  resources :gtrends, except: [:index, :edit, :update]
  
end
