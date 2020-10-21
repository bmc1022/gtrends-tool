FactoryBot.define do
  
  factory :keyword do
    sequence(:kw) { |n| "kw#{n}" }
    
    association :gtrend
  end

end
