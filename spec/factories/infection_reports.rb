FactoryBot.define do
  factory :infection_report do
    association :reporter, factory: :survivor
    association :reported, factory: :survivor
    reporter_latitude { reporter.latitude }
    reporter_longitude { reporter.longitude }

    trait :with_infected_reporter do
      association :reporter, factory: [ :survivor, :infected ]
    end

    trait :with_infected_reported do
      association :reported, factory: [ :survivor, :infected ]
    end
  end
end
