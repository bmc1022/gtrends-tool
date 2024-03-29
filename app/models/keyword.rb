# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :gtrend, inverse_of: :keywords

  validates :term, presence: true,
                   uniqueness: { case_sensitive: false,
                                 scope: :gtrend_id,
                                 message: "'%{value}' has already been taken" }

  scope :desc_5y_avg, -> { order(avg_5y: :desc) }
end
