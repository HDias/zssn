FactoryBot.define do
  factory :inventory_item do
    association :survivor
    association :item
    quantity { rand(1..10) }
  end
end
