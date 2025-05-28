# frozen_string_literal: true

class Inventory
  attr_reader :survivor

  def initialize(survivor)
    @survivor = survivor
  end

  def add_item(item)
    global_stock = item.global_item_stock
    return false unless global_stock && global_stock.total_quantity > 0

    ActiveRecord::Base.transaction do
      inventory_item = survivor.inventory_items.find_or_initialize_by(item: item)
      inventory_item.quantity += 1
      inventory_item.save!

      global_stock.total_quantity -= 1
      global_stock.save!
    end
  end
end