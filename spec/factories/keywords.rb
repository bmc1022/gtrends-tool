# frozen_string_literal: true

FactoryBot.define do
  factory :keyword do
    association :gtrend

    sequence(:term) { |n| "keyword#{n}" }

    trait :with_averages do
      sequence(:avg_5y) { |n| n * 10 }
    end

    trait :with_random_averages do
      avg_5y { rand(1..99) }
    end
  end
end
