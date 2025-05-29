# frozen_string_literal: true

class Item < ApplicationRecord
  enum :kind, {
    water: "water",
    food: "food",
    medicine: "medicine",
    ammunition: "ammunition"
  }

  has_many :inventory_items
  has_one :global_item_stock

  validates :name, presence: true
  validates :point_value, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :kind, presence: true, inclusion: { in: %w[water food medicine ammunition] }
end
