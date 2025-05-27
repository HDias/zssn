# frozen_string_literal: true

class InfectionReport < ApplicationRecord
  validates :reporter_latitude, presence: true,
      numericality: {
      greater_than_or_equal_to: -90,
      less_than_or_equal_to: 90
    }
  validates :reporter_longitude, presence: true,
    numericality: {
      greater_than_or_equal_to: -180,
      less_than_or_equal_to: 180
    }

  belongs_to :reporter, class_name: "Survivor", foreign_key: "reporter_id"
  belongs_to :reported, class_name: "Survivor", foreign_key: "reported_id", counter_cache: :infection_reports

  validate :reporter_cannot_report_themselves
  validate :reporter_cannot_report_same_person_twice
  validate :reporter_cannot_be_infected

  after_create :check_and_update_infection_status

  private

  def reporter_cannot_report_themselves
    if reporter_id == reported_id
      errors.add(:reported_id, "can't report yourself")
    end
  end

  def reporter_cannot_report_same_person_twice
    if InfectionReport.exists?(reporter_id: reporter_id, reported_id: reported_id)
      errors.add(:reported_id, "already reported this survivor")
    end
  end

  def reporter_cannot_be_infected
    if reporter&.infected?
      errors.add(:reporter_id, "infected survivors cannot report others")
    end
  end

  def check_and_update_infection_status
    reported.update(infected: true) if reported.infection_reports >= 3
  end
end
