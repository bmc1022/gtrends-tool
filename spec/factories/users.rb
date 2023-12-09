# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@email.com" }
    password { "password" }
    password_confirmation { "password" }

    after(:build) { |user| user.add_role(:registered) }

    trait :admin do
      after(:build) { |user| user.add_role(:admin) }
    end
  end
end
