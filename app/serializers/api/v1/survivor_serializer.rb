# frozen_string_literal: true

module Api
  module V1
    class SurvivorSerializer
      def initialize(survivor)
        @survivor = survivor
      end

      def as_json
        {
          id: @survivor.id,
          name: @survivor.name,
          age: @survivor.age,
          gender: @survivor.gender,
          latitude: @survivor.latitude,
          longitude: @survivor.longitude,
          infected: @survivor.infected,
          infection_reports: @survivor.infection_reports
        }
      end
    end
  end
end
