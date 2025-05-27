# frozen_string_literal: true

module Api
  module V1
    class SurvivorsController < ApplicationController
      def create
        @survivor = Survivor.new(survivor_params)

        if @survivor.save
          render json: SurvivorSerializer.new(@survivor).as_json, status: :created
        else
          render json: { errors: @survivor.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def survivor_params
        params.require(:survivor).permit(
          :name,
          :age,
          :gender,
          :latitude,
          :longitude
        )
      end
    end
  end
end
