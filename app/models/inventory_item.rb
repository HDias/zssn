class InventoryItem < ApplicationRecord
  belongs_to :survivor
  belongs_to :item

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :item_id, uniqueness: { scope: :survivor_id, message: "already exists in survivor's inventory" }
end
