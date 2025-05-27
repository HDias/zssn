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

      def update
        @survivor = Survivor.find(params[:id])

        if @survivor.update(location_params)
          render json: SurvivorSerializer.new(@survivor).as_json, status: :ok
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

      def location_params
        params.require(:survivor).permit(:latitude, :longitude)
      end
    end
  end
end
