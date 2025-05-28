FactoryBot.define do
  factory :inventory_item do
    association :inventory
    association :item, :water
    quantity { 1 }
  end
end
