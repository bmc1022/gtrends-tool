class Gtrend < ApplicationRecord

  has_many :keywords, dependent: :destroy, inverse_of: :gtrend

  attr_reader :kws

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }, 
                   uniqueness: { case_sensitive: false }
  validates :kws,  presence: true

  def kws=(list)
    list.split(/[\n,]/).reject(&:empty?).map(&:strip)
  end

end
