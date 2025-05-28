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
          patch "/api/v1/survivors/#{survivor.id}/inventory", params: { item_id: item.id }

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
          patch "/api/v1/survivors/#{survivor.id}/inventory", params: { item_id: 0 }

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
        patch "/api/v1/survivors/#{survivor.id}/inventory", params: { item_id: item.id }

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body['error']).to include('Resource not found')
      end
    end

    context 'when survivor does not exist' do
      it 'returns not found status' do
        patch "/api/v1/survivors/0/inventory", params: { item_id: item.id }

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body['error']).to include('Resource not found')
      end
    end
  end
end