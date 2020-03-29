class Gtrend < ApplicationRecord
  
  has_many :keywords, dependent: :destroy, inverse_of: :gtrend
  accepts_nested_attributes_for :keywords
  
  validates_associated :keywords
  validates :name, presence: true, uniqueness: { case_sensitive: false },
                   length: { minimum: 2, maximum: 100 }
  
  def add_keywords=(keywords)
    self.keywords = keywords.split(',').map do |kw|
      Keyword.where(kw: kw.strip).first_or_create!
    end
  end
  
end
