Rails.application.routes.draw do
  
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :gtrends, only: [:index, :create, :destroy]
    end
  end
  
  devise_for :users, skip: [:registrations, :sessions], 
                     controllers: { sessions: 'sessions' }
  devise_scope :user do
    get  'login' => 'sessions#new', :as => :new_user_session
    post 'login' => 'sessions#create', :as => :user_session
    delete 'logout' => 'sessions#destroy', :as => :destroy_user_session
  end
  
  authenticate :user do
    resources :gtrends, only: [:index, :create, :destroy], path: '/'
  end
  
end
