# frozen_string_literal: true

class Gtrend < ApplicationRecord
  has_many :keywords, dependent: :destroy, inverse_of: :gtrend

  before_save :update_kws, unless: :skip_kws?

  attribute :kws, :text

  validates :name, presence: true, length: { minimum: 2, maximum: 100 },
                   uniqueness: { case_sensitive: false }
  validates :kws,  presence: true, length: { maximum: 5000 }, unless: :skip_kws?
  validate  :kw_count, on: :create

  def highest_5y_avg
    @highest_5y_avg ||= keywords.maximum(:avg_5y)
  end

  private

  def kws_to_list
    kws.split(/[\n,]/).map(&:strip).reject!(&:empty?)
  end

  def kw_count
    errors.add(:kws, "Keyword count must not exceed 100.") if kws_to_list.size > 100
  end

  def update_kws
    self.kws = kws_to_list
  end

  # :kws is a virtual/non-persisted attribute and should be skipped on updates to
  # gtrend records since the assigned data will no longer exist after save.
  def skip_kws?
    persisted?
  end
end
