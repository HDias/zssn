FactoryBot.define do
  factory :survivor do
    sequence(:name) { |n| "#{FFaker::Name.name} #{n}" }
    age { FFaker::Random.rand(18..60) }
    gender { %w[male female other].sample }
    latitude { FFaker::Geolocation.lat.round(6) }
    longitude { FFaker::Geolocation.lng.round(6) }
    infected { false }
    infection_reports { 0 }

    trait :infected do
      infected { true }
      infection_reports { 3 }
    end

    trait :with_inventory do
      after(:create) do |survivor|
        inventory = create(:inventory, survivor:)
        create_list(:inventory_item, rand(1..5), inventory:)
      end
    end
  end
end
