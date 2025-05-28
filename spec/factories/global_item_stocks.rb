FactoryBot.define do
  factory :global_item_stock do
    association :item, :water
    total_quantity { 100 }
  end
end
