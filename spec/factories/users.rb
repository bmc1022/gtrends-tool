# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@email.com" }
    password { "password" }
    password_confirmation { "password" }

    trait :admin do
      after(:create) { |user| user.add_role(:admin) }
    end
  end
end
