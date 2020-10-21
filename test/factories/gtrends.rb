FactoryBot.define do
  
  factory :gtrend do
    sequence(:name) { |n| "test#{n}"}
    kws { ['lorem', 'ipsum', 'dolor'] }
  end
  
end
