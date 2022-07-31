FactoryBot.define do

  factory :keyword do
    sequence(:kw) { |n| "kw#{n}" }

    association :gtrend

    trait :with_averages do
      sequence(:avg_5y) { |n| n }
    end

    trait :with_random_averages do
      avg_5y { rand(1..99) }
    end
  end

end
