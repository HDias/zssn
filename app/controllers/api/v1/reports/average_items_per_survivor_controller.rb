# frozen_string_literal: true

module Api
  module V1
    module Reports
      class AverageItemsPerSurvivorController < ApplicationController
        def index
          render json: {
            average: Survivor.average_items_per_survivor
          }
        end
      end
    end
  end
end