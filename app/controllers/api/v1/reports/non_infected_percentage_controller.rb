# frozen_string_literal: true

module Api
  module V1
    module Reports
      class NonInfectedPercentageController < ApplicationController
        def index
          render json: {
            percentage: Survivor.non_infected_percentage
          }
        end
      end
    end
  end
end
