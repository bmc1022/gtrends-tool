Rails.application.routes.draw do
  
  devise_for :admins, skip: [:sessions], 
          controllers: { registrations: 'registrations', sessions: 'sessions' }
  devise_scope :admin do
    get  'login' => 'sessions#new', :as => :new_admin_session
    post 'login' => 'sessions#create', :as => :admin_session
    delete 'logout' => 'sessions#destroy', :as => :destroy_admin_session
  end
  
  authenticate :admin do
    resources :gtrends, only: [:index, :create, :destroy], path: '/'
  end
  
end
