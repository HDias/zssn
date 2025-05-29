# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Reports::PointsLostByInfectedController, type: :request do
  let!(:water) { create(:item, :water, point_value: 4) }
  let!(:food) { create(:item, :food, point_value: 3) }
  let!(:medication) { create(:item, :medicine, point_value: 2) }
  let!(:ammunition) { create(:item, :ammunition, point_value: 1) }

  let!(:water_stock) { create(:global_item_stock, item: water, total_quantity: 10) }
  let!(:food_stock) { create(:global_item_stock, item: food, total_quantity: 10) }
  let!(:medication_stock) { create(:global_item_stock, item: medication, total_quantity: 10) }
  let!(:ammunition_stock) { create(:global_item_stock, item: ammunition, total_quantity: 10) }

  describe '#index' do
    let!(:infected_survivor) { create(:survivor, infected: true) }
    let!(:item1) { create(:inventory_item, inventory: infected_survivor.inventory, item: water, quantity: 1) }
    let!(:item2) { create(:inventory_item, inventory: infected_survivor.inventory, item: food, quantity: 1) }

    before do
      get '/api/v1/reports/points_lost_by_infected'
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the total points lost by infected survivors' do
      json_response = JSON.parse(response.body)
      expect(json_response['points_lost']).to eq(7)
    end
  end
end
