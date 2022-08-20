# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :gtrend, inverse_of: :keywords

  validates :kw, presence: true, uniqueness: { case_sensitive: false, scope: :gtrend,
                                 message: "'%{value}' has already been taken" }
end
