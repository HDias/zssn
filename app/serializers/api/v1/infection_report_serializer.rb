# frozen_string_literal: true
module Api
  module V1
    class InfectionReportSerializer
      def initialize(infection_report)
        @infection_report = infection_report
      end

      def as_json
        {
          id: @infection_report.id,
          reporter: {
            id: @infection_report.reporter.id,
            name: @infection_report.reporter.name
          },
          reported: {
            id: @infection_report.reported.id,
            name: @infection_report.reported.name,
            infected: @infection_report.reported.infected,
            infection_reports: @infection_report.reported.infection_reports
          },
          reporter_latitude: @infection_report.reporter_latitude,
          reporter_longitude: @infection_report.reporter_longitude
        }
      end
    end
  end
end
