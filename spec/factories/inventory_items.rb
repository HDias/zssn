FactoryBot.define do
  factory :inventory_item do
    association :inventory
    association :item
    quantity { 1 }
  end
end
