FactoryBot.define do

  factory :gtrend do
    sequence(:name) { |n| "test#{n}"}
    kws { 'lorem, ipsum, dolor' }

    factory :gtrend_with_keywords do
      transient do
        keyword_count { 3 }
      end

      after(:create) do |trend, evaluator|
        create_list(:keyword, evaluator.keyword_count,
                    :with_random_averages, gtrend: trend)
      end
    end
  end

end
