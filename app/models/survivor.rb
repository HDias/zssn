# frozen_string_literal: true

class Survivor < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :age, presence: true,
    numericality: {
      only_integer: true,
      greater_than: 0
    }
  validates :gender, presence: true, inclusion: { in: %w[male female other] }
  validates :latitude, presence: true,
    numericality: {
      greater_than_or_equal_to: -90,
      less_than_or_equal_to: 90
    }
  validates :longitude, presence: true,
    numericality: {
    greater_than_or_equal_to: -180,
    less_than_or_equal_to: 180
    }
  validates :infected, inclusion: { in: [ true, false ] }
  validates :infection_reports, presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 3
    }

  has_many :reported_infections, class_name: "InfectionReport", foreign_key: "reporter_id"
  has_many :infection_reports_received, class_name: "InfectionReport", foreign_key: "reported_id"
  has_one :inventory, dependent: :destroy
  has_many :inventory_items, through: :inventory

  after_create :create_empty_inventory

  private

  def create_empty_inventory
    create_inventory
  end
end
