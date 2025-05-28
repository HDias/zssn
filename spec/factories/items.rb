FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Item #{n}" }
    latitude { rand(-90.0..90.0) }
    longitude { rand(-180.0..180.0) }

    trait :water do
      name { 'Water' }
      kind { 'water' }
      point_value { 4 }
    end

    trait :food do
      name { 'Food' }
      kind { 'food' }
      point_value { 3 }
    end

    trait :medicine do
      name { 'Medicine' }
      kind { 'medicine' }
      point_value { 2 }
    end

    trait :ammunition do
      name { 'Ammunition' }
      kind { 'ammunition' }
      point_value { 1 }
    end
  end
end
