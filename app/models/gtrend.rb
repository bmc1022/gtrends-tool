class Gtrend < ApplicationRecord
  
  has_many :keywords, dependent: :destroy, inverse_of: :gtrend

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }, 
                   uniqueness: { case_sensitive: false }
                   

  def add_keywords=(keywords)
    self.keywords = keywords.split(/[\n,]/).reject(&:empty?).map do |keyword|
      Keyword.create!(kw: keyword.strip, gtrend: self)
    end
  end
  
end
