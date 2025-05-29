# frozen_string_literal: true

module Api
  module V1
    module Reports
      class PointsLostByInfectedController < ApplicationController
        def index
          render json: {
            points_lost: Survivor.points_lost_by_infected
          }
        end
      end
    end
  end
end
