# frozen_string_literal: true

module Api
  module V1
    class TradesController < ApplicationController
      def create
        trade = Trade.new(barterer: find_barterer, counterpart: find_counterpart)

        if trade.exchange_items(barterer_items, counterpart_items)
          render json: { message: "Trade completed successfully" }, status: :ok
        else
          render json: { errors: trade.errors }, status: :unprocessable_entity
        end
      end

      private

      def find_barterer
        Survivor.find(params[:barterer_id])
      end

      def find_counterpart
        Survivor.find(params[:counterpart_id])
      end

      def barterer_items = params.require(:barterer_items).permit!.to_unsafe_h

      def counterpart_items = params.require(:counterpart_items).permit!.to_unsafe_h
    end
  end
end
