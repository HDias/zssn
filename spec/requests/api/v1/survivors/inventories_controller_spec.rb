# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Survivors::InventoriesController, type: :request do
  let!(:survivor) { create(:survivor, :with_inventory) }
  let!(:item) { create(:item, :water) }
  let!(:global_item_stock) { create(:global_item_stock, item:, total_quantity: 10) }

  describe '#update' do
    context 'when the survivor is not infected' do
      before do
        survivor.update(infected: false)
      end

      context 'with valid parameters' do
        it 'updates the inventory' do
          patch "/api/v1/survivors/#{survivor.id}/inventory/#{item.id}"

          expect(response).to have_http_status(:ok)
          response_body = response.parsed_body
          expect(response_body).to include(
            'id',
            'survivor',
            'total_items',
            'items'
          )

          expect(response_body['survivor']).to include(
            'id',
            'name',
            'infected',
            'infection_reports'
          )

          expect(response_body['items']).to be_an(Array)
          expect(response_body['items'].first).to include(
            'id',
            'name',
            'quantity'
          )
        end
      end

      context 'with invalid parameters' do
        it 'returns unprocessable entity status' do
          patch "/api/v1/survivors/#{survivor.id}/inventory/0"

          expect(response).to have_http_status(:not_found)
          expect(response.parsed_body['error']).to include('Resource not found')
        end
      end
    end

    context 'when the survivor is infected' do
      before do
        survivor.update(infected: true)
      end

      it 'returns not found status' do
        patch "/api/v1/survivors/#{survivor.id}/inventory/#{item.id}"

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body['error']).to include('Resource not found')
      end
    end

    context 'when survivor does not exist' do
      it 'returns not found status' do
        patch "/api/v1/survivors/0/inventory/#{item.id}"

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body['error']).to include('Resource not found')
      end
    end
  end

  describe '#destroy' do
    let(:survivor) { create(:survivor, infected: false) }
    let(:item) { create(:item, :water) }
    let!(:inventory_item) { create(:inventory_item, inventory: survivor.inventory, item:, quantity: 2) }

    context 'when the request is valid' do
      before do
        delete "/api/v1/survivors/#{survivor.id}/inventory/#{item.id}"
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'decreases the item quantity by 1' do
        expect(survivor.inventory.inventory_items.find_by(item: item).quantity).to eq(1)
      end

      it 'returns the updated inventory' do
        expect(response.parsed_body).to include('id' => survivor.inventory.id)
      end
    end

    context 'when the survivor is infected' do
      let(:infected_survivor) { create(:survivor, infected: true) }

      it 'returns status code 404' do
        delete "/api/v1/survivors/#{infected_survivor.id}/inventory/#{item.id}"

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the item is not in inventory' do
      let(:other_item) { create(:item, :food) }

      before do
        delete "/api/v1/survivors/#{survivor.id}/inventory/#{other_item.id}"
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        expect(response.parsed_body['error']).to eq('Could not remove item from inventory')
      end
    end

    context 'when the survivor does not exist' do
      it 'returns status code 404' do
        delete "/api/v1/survivors/0/inventory/#{item.id}"

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
