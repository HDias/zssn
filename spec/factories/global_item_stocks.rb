FactoryBot.define do
  factory :global_item_stock do
    association :item
    total_quantity { 100 }
  end
end
