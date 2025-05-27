require 'rails_helper'

RSpec.describe Api::V1::SurvivorsController, type: :request do
  describe '#update' do
    let(:survivor) do
      Survivor.create!(
        name: 'John Doe',
        age: 30,
        gender: 'male',
        latitude: -23.550520,
        longitude: -46.633308
      )
    end

    let(:valid_location_attributes) do
      {
        survivor: {
          latitude: -22.550520,
          longitude: -45.633308
        }
      }
    end

    let(:invalid_location_attributes) do
      {
        survivor: {
          latitude: 'invalid_latitude',
          longitude: 'invalid_longitude'
        }
      }
    end

    context 'with valid location parameters' do
      it 'updates the survivor location' do
        patch "/api/v1/survivors/#{survivor.id}", params: valid_location_attributes

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['latitude']).to eq(-22.550520)
        expect(response.parsed_body['longitude']).to eq(-45.633308)
      end

      it 'does not update other attributes' do
        original_name = survivor.name
        original_age = survivor.age
        original_gender = survivor.gender

        patch "/api/v1/survivors/#{survivor.id}", params: valid_location_attributes

        expect(response.parsed_body['name']).to eq(original_name)
        expect(response.parsed_body['age']).to eq(original_age)
        expect(response.parsed_body['gender']).to eq(original_gender)
      end
    end

    context 'with invalid location parameters' do
      it 'returns unprocessable entity status' do
        patch "/api/v1/survivors/#{survivor.id}", params: invalid_location_attributes

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        patch "/api/v1/survivors/#{survivor.id}", params: invalid_location_attributes

        expect(response.parsed_body['errors']).to be_present
      end
    end

    context 'when survivor is not found' do
      it 'returns not found status' do
        patch '/api/v1/survivors/999999', params: valid_location_attributes

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
