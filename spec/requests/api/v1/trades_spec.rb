require 'rails_helper'

RSpec.describe Api::V1::TradesController, type: :request do
  let(:barterer) { create(:survivor) }
  let(:counterpart) { create(:survivor) }
  let(:water) { create(:item, :water) }
  let(:food) { create(:item, :food) }
  let(:medicine) { create(:item, :medicine) }
  let(:ammunition) { create(:item, :ammunition) }

  before do
    create(:global_item_stock, item: water, total_quantity: 10)
    create(:global_item_stock, item: food, total_quantity: 10)
    create(:global_item_stock, item: medicine, total_quantity: 10)
    create(:global_item_stock, item: ammunition, total_quantity: 10)

    2.times { barterer.inventory.add_item(water) }
    3.times { barterer.inventory.add_item(food) }
    2.times { counterpart.inventory.add_item(medicine) }
    4.times { counterpart.inventory.add_item(ammunition) }
  end

  describe '#create' do
    context 'with valid trade parameters' do
      let(:valid_params) do
        {
          barterer_id: barterer.id,
          counterpart_id: counterpart.id,
          barterer_items: { water.id => 1, food.id => 1 }, # 4 + 3 = 7 points
          counterpart_items: { medicine.id => 2, ammunition.id => 3 } # (2 * 2) + (1 * 3) = 7 points
        }
      end

      it 'creates a successful trade' do
        expect {
          post '/api/v1/trades', params: valid_params
        }.to change { barterer.inventory.inventory_items.find_by(item: medicine)&.quantity }.from(nil).to(2)
          .and change { barterer.inventory.inventory_items.find_by(item: ammunition)&.quantity }.from(nil).to(3)
          .and change { counterpart.inventory.inventory_items.find_by(item: water)&.quantity }.from(nil).to(1)
          .and change { counterpart.inventory.inventory_items.find_by(item: food)&.quantity }.from(nil).to(1)

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['message']).to eq('Trade completed successfully')
      end
    end

    context 'with invalid trade parameters' do
      context 'when point values are not equal' do
        let(:invalid_params) do
          {
            barterer_id: barterer.id,
            counterpart_id: counterpart.id,
            barterer_items: { water.id => 1 }, # 4 points
            counterpart_items: { ammunition.id => 3 } # 3 points
          }
        end

        it 'returns unprocessable entity status' do
          post '/api/v1/trades', params: invalid_params

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body['errors']).to include('Point values must be equal for both sides of the trade')
        end
      end

      context 'when survivor does not have enough items' do
        let(:invalid_params) do
          {
            barterer_id: barterer.id,
            counterpart_id: counterpart.id,
            barterer_items: { water.id => 3 }, # Trying to trade 3 waters when only has 2
            counterpart_items: { medicine.id => 6 } # 12 points
          }
        end

        it 'returns unprocessable entity status' do
          post '/api/v1/trades', params: invalid_params

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body['errors']).to include("#{barterer.name} doesn't have enough #{water.name}")
        end
      end

      context 'when survivor is infected' do
        let(:infected_survivor) { create(:survivor, infected: true) }
        let(:invalid_params) do
          {
            barterer_id: infected_survivor.id,
            counterpart_id: counterpart.id,
            barterer_items: { water.id => 1 },
            counterpart_items: { medicine.id => 2 }
          }
        end

        it 'returns unprocessable entity status' do
          post '/api/v1/trades', params: invalid_params

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body['errors']).to include('Infected survivors cannot trade')
        end
      end
    end
  end
end