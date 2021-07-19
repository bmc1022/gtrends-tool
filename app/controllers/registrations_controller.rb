class RegistrationsController < Devise::RegistrationsController
  
  layout 'auth', only: [:new]

end
