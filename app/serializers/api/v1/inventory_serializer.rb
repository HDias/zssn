# frozen_string_literal: true

module Api
  module V1
    class InventorySerializer
      def initialize(inventory)
        @inventory = inventory
      end

      def as_json
        {
          id: @inventory.id,
          survivor: {
            id: @inventory.survivor.id,
            name: @inventory.survivor.name,
            infected: @inventory.survivor.infected,
            infection_reports: @inventory.survivor.infection_reports
          },
          total_items: @inventory.total_items,
          items: @inventory.inventory_items.map do |inventory_item|
            {
              id: inventory_item.item.id,
              name: inventory_item.item.name,
              quantity: inventory_item.quantity
            }
          end
        }
      end
    end
  end
end
