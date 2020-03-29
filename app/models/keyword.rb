class Keyword < ApplicationRecord
  
  belongs_to :gtrend, inverse_of: :keywords
  
  validates :gtrend, presence: true
  validates :kw, presence: true, uniqueness: { case_sensitive: false }, 
                 length: { minimum: 2, maximum: 300 }
  
end
