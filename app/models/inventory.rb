# frozen_string_literal: true

class Inventory < ApplicationRecord
  belongs_to :survivor
  has_many :inventory_items, dependent: :destroy
  has_many :items, through: :inventory_items

  validates :total_items, numericality: { greater_than_or_equal_to: 0 }

  def add_item(item)
    return false unless item.global_item_stock.total_quantity.positive?

    ActiveRecord::Base.transaction do
      inventory_item = inventory_items.find_or_initialize_by(item:)
      inventory_item.save!
      InventoryItem.increment_counter(:quantity, inventory_item.id)
      item.global_item_stock.decrement!(:total_quantity)

      update_total_items
    end

    self
  end

  def remove_item(item)
    inventory_item = inventory_items.find_by(item:)
    return false unless inventory_item && inventory_item.quantity > 0

    ActiveRecord::Base.transaction do
      inventory_item.quantity -= 1
      if inventory_item.quantity.zero?
        inventory_item.destroy
      else
        inventory_item.save
      end
      item.global_item_stock.increment!(:total_quantity)
      update_total_items
    end

    true
  end

  private

  def update_total_items
    update_column(:total_items, inventory_items.sum(:quantity))
  end
end