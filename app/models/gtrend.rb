# frozen_string_literal: true

class Gtrend < ApplicationRecord
  include CableReady::Broadcaster

  after_update_commit :broadcast_update

  has_many :keywords, dependent: :destroy, inverse_of: :gtrend
  belongs_to :user, optional: true

  attribute :kws, :text

  validates :name, presence: true, length: { in: 2..25 }, uniqueness: { case_sensitive: false }
  # :kws is a virtual/non-persisted attribute and validations on it should be skipped on updates to
  # gtrend records since the assigned data will no longer exist after reload.
  with_options on: :create do
    validates :kws, presence: true
    validate  :kws_max_chars
    validate  :kw_count
  end

  scope :seeded_trends, -> { where(user_id: nil, guest_id: nil) }

  def kws
    read_attribute(:kws).to_s.split(/[\n,]/).map(&:strip).uniq(&:downcase).compact_blank
  end

  def highest_5y_avg
    @highest_5y_avg ||= keywords.maximum(:avg_5y)
  end

  def pundit_user
    user || Guest.new(guest_id)
  end

  private

  def kws_max_chars
    errors.add(:kws, "Keywords cannot be longer than 5000 characters") if kws.join.length > 5000
  end

  def kw_count
    errors.add(:kws, "Keyword count must not exceed 100.") if kws.size > 100
  end

  def broadcast_update
    args = { partial: "gtrends/gtrend", locals: { gtrend: self } }
    html = ApplicationController.render_with_signed_in_user(user, **args)

    cable_ready[GtrendsChannel].morph(selector: dom_id(self), html:).broadcast_to(self)
  end
end
