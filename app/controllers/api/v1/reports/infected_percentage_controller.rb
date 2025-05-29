# frozen_string_literal: true

module Api
  module V1
    module Reports
      class InfectedPercentageController < ApplicationController
        def index
          render json: {
            percentage: Survivor.infected_percentage
          }
        end
      end
    end
  end
end