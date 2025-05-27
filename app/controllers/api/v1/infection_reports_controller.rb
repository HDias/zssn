# frozen_string_literal: true

module Api
  module V1
    class InfectionReportsController < ApplicationController
      def create
        @infection_report = InfectionReport.new(infection_report_params)

        if @infection_report.save
          render json: InfectionReportSerializer.new(@infection_report).as_json, status: :created
        else
          render json: { errors: @infection_report.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def infection_report_params
        params
          .require(:infection_report)
          .permit(
            :reporter_id,
            :reported_id,
            :reporter_latitude,
            :reporter_longitude
          )
      end
    end
  end
end
