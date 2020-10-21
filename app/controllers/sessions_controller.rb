class SessionsController < Devise::SessionsController
  
  layout 'auth', only: [:new]
  
end
