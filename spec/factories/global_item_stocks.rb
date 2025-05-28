FactoryBot.define do
  factory :global_item_stock do
    association :item
    total_quantity { rand(1..100) }
  end
end
