# frozen_string_literal: true

class Gtrend < ApplicationRecord
  has_many :keywords, dependent: :destroy, inverse_of: :gtrend

  attribute :kws, :text

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: { case_sensitive: false }
  # :kws is a virtual/non-persisted attribute and validations on it should be skipped on updates to
  # gtrend records since the assigned data will no longer exist after reload.
  with_options on: :create do
    validates :kws, presence: true
    validate  :kws_max_chars
    validate  :kw_count
  end

  def kws
    read_attribute(:kws).to_s.split(/[\n,]/).map(&:strip).compact_blank
  end

  def highest_5y_avg
    @highest_5y_avg ||= keywords.maximum(:avg_5y)
  end

  private

  def kws_max_chars
    errors.add(:kws, "Keywords cannot be longer than 5000 characters") if kws.join.length > 5000
  end

  def kw_count
    errors.add(:kws, "Keyword count must not exceed 100.") if kws.size > 100
  end
end
