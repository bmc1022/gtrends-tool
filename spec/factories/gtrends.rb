# frozen_string_literal: true

FactoryBot.define do
  factory :gtrend do
    sequence(:name) { |n| "test#{n}" }
    kws { "lorem, ipsum, dolor" }

    factory :gtrend_with_keywords do
      transient do
        keyword_count { 3 }
      end

      after(:create) do |trend, evaluator|
        create_list(:keyword, evaluator.keyword_count, :with_random_averages, gtrend: trend)
      end
    end

    trait :created_by_user do
      association :user
    end

    trait :created_by_guest do
      guest_id { SecureRandom.uuid }
    end

    trait :seeded do
      user_id { nil }
      guest_id { nil }
    end
  end
end
