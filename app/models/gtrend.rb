class Gtrend < ApplicationRecord
  
  has_many :keywords, :dependent => :destroy
  
  validates :name, presence: true, uniqueness: { case_sensitive: false },
                   length: { minimum: 2, maximum: 100 }

end
