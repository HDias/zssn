FactoryBot.define do
  factory :inventory do
    association :survivor
    total_items { 0 }

    trait :with_items do
      after(:create) do |inventory|
        create_list(:inventory_item, 2, inventory: inventory)
        inventory.update_column(:total_items, inventory.inventory_items.sum(:quantity))
      end
    end

    trait :with_specific_items do
      after(:create) do |inventory|
        create(:inventory_item, inventory: inventory, item: create(:item, :water))
        create(:inventory_item, inventory: inventory, item: create(:item, :food))
        inventory.update_column(:total_items, inventory.inventory_items.sum(:quantity))
      end
    end
  end
end