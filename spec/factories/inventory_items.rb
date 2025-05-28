FactoryBot.define do
  factory :inventory_item do
    association :survivor
    association :item
    quantity { 1 }
  end
end
