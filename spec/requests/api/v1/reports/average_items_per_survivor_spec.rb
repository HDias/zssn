require 'rails_helper'

RSpec.describe Api::V1::Reports::AverageItemsPerSurvivorController, type: :request do
  let!(:water) { create(:item, name: 'Water', kind: 'water', point_value: 4) }
  let!(:food) { create(:item, name: 'Food', kind: 'food', point_value: 3) }
  let!(:medication) { create(:item, name: 'Medication', kind: 'medicine', point_value: 2) }
  let!(:ammunition) { create(:item, name: 'Ammunition', kind: 'ammunition', point_value: 1) }
  let!(:water_stock) { create(:global_item_stock, item: water, total_quantity: 10) }
  let!(:food_stock) { create(:global_item_stock, item: food, total_quantity: 10) }
  let!(:medication_stock) { create(:global_item_stock, item: medication, total_quantity: 10) }
  let!(:ammunition_stock) { create(:global_item_stock, item: ammunition, total_quantity: 10) }

  describe '#index' do
    let!(:survivor1) { create(:survivor) }
    let!(:survivor2) { create(:survivor) }
    let!(:item1) { create(:inventory_item, inventory: survivor1.inventory, item: water, quantity: 1) }
    let!(:item2) { create(:inventory_item, inventory: survivor1.inventory, item: food, quantity: 1) }
    let!(:item3) { create(:inventory_item, inventory: survivor2.inventory, item: medication, quantity: 1) }

    before do
      get '/api/v1/reports/average_items_per_survivor'
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the average items per survivor' do
      json_response = JSON.parse(response.body)
      expect(json_response['average']).to eq(1.5)
    end

    context 'with different quantities of items' do
      let!(:survivor3) { create(:survivor) }
      let!(:item4) { create(:inventory_item, inventory: survivor3.inventory, item: water, quantity: 3) }
      let!(:item5) { create(:inventory_item, inventory: survivor3.inventory, item: ammunition, quantity: 2) }

      before do
        get '/api/v1/reports/average_items_per_survivor'
      end

      it 'returns the correct average with varying quantities' do
        json_response = JSON.parse(response.body)
        expect(json_response['average']).to eq(2.67)
      end
    end
  end
end
