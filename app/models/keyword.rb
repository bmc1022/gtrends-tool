class Keyword < ApplicationRecord
  
  belongs_to :gtrend
  
  validates :kw, presence: true, uniqueness: { case_sensitive: false }, 
                 length: { minimum: 2, maximum: 300 }
  validates :gtrend, presence: true
  
end
