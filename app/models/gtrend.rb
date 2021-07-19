class Gtrend < ApplicationRecord

  has_many :keywords, dependent: :destroy, inverse_of: :gtrend

  before_save :convert_kws_to_list, unless: :skip_kws?

  attribute :kws, :text
  
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }, 
                   uniqueness: { case_sensitive: false }
  validates :kws,  presence: true, length: { maximum: 5000 }, unless: :skip_kws?
  validate  :kw_count, on: :create

  private

    def convert_kws_to_list
      self.kws = self.kws.split(/[\n,]/).reject(&:empty?).map(&:strip)
    end
    
    def kw_count
      errors.add(:kws, 'Keyword count must not exceed 100.') if self.kws.size > 100
    end
    
    # kws is a non-persisted attribute and should be skipped on updates
    # to gtrend records since the kws data will no longer exist after save
    def skip_kws?
      self.persisted?
    end

end
