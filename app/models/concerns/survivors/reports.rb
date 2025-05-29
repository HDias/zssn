# frozen_string_literal: true

module Survivors
  module Reports
    extend ActiveSupport::Concern

    class_methods do
      def infected_percentage
        total = count
        return 0 if total.zero?

        infected_count = where(infected: true).count
        (infected_count.to_f / total * 100).round(2)
      end

      def non_infected_percentage
        total = count
        return 0 if total.zero?

        non_infected_count = where(infected: false).count
        (non_infected_count.to_f / total * 100).round(2)
      end

      def average_items_per_survivor
        total = count
        return 0 if total.zero?

        total_items = joins(inventory: :inventory_items)
                      .sum('inventory_items.quantity')
        (total_items.to_f / total).round(2)
      end

      def points_lost_by_infected
        where(infected: true)
          .joins(inventory: { inventory_items: :item })
          .sum('inventory_items.quantity * items.point_value')
      end
    end
  end
end
