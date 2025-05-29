# frozen_string_literal: true

class GlobalItemStock < ApplicationRecord
  belongs_to :item

  validates :total_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :item_id, uniqueness: { message: "already has a global stock record" }
end
