# frozen_string_literal: true

class InventoryItem < ApplicationRecord
  belongs_to :inventory
  belongs_to :item

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :item_id, uniqueness: { scope: :inventory_id, message: "already exists in inventory" }
end
