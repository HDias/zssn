# frozen_string_literal: true

module Api
  module V1
    module Survivors
      class InventoriesController < ApplicationController
        before_action :set_survivor

        def update
          @inventory = @survivor.inventory
          item = Item.find(params[:item_id])

          if @inventory.add_item(item)
            render json: InventorySerializer.new(@inventory).as_json, status: :ok
          else
            render json: { errors: @inventory.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @inventory = @survivor.inventory
          item = Item.find(params[:item_id])

          if @inventory.remove_item(item)
            render json: InventorySerializer.new(@inventory).as_json, status: :ok
          else
            render json: { error: "Could not remove item from inventory" }, status: :unprocessable_entity
          end
        end

        private

        def set_survivor
          @survivor = Survivor.where(infected: false, id: params[:survivor_id]).take!
        end
      end
    end
  end
end