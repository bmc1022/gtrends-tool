# frozen_string_literal: true

namespace :cleanup do
  desc "Delete expired guest gtrends"
  task expired_gtrends: :environment do
    expired_gtrends = Gtrend.where("guest_id IS NOT NULL AND created_at < ?", 1.day.ago)
    expired_gtrends.destroy_all
  end
end
