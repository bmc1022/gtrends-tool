class Keyword < ApplicationRecord
  
  belongs_to :gtrend, inverse_of: :keywords
  
  validates :kw, presence: true, length: { minimum: 2, maximum: 300 }, 
                 uniqueness: { case_sensitive: false, scope: :gtrend, 
                               message: "'%{value}' has already been taken" }
  
end
