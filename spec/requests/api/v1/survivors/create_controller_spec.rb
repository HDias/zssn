require 'rails_helper'

RSpec.describe Api::V1::SurvivorsController, type: :request do
  describe '#create' do
    let(:valid_attributes) do
      {
        survivor: {
          name: 'John Doe',
          age: 30,
          gender: 'male',
          latitude: -23.550520,
          longitude: -46.633308
        }
      }
    end

    let(:invalid_attributes) do
      {
        survivor: {
          name: '',
          age: -1,
          gender: 'invalid_gender',
          latitude: 'invalid_latitude',
          longitude: 'invalid_longitude'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new survivor' do
        expect {
          post '/api/v1/survivors', params: valid_attributes
        }.to change(Survivor, :count).by(1)
      end

      it 'returns the created survivor' do
        post '/api/v1/survivors', params: valid_attributes

        expect(response).to have_http_status(:created)
        expect(response.parsed_body['name']).to eq('John Doe')
        expect(response.parsed_body['age']).to eq(30)
        expect(response.parsed_body['gender']).to eq('male')
        expect(response.parsed_body['latitude']).to eq(-23.550520)
        expect(response.parsed_body['longitude']).to eq(-46.633308)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new survivor' do
        expect {
          post '/api/v1/survivors', params: invalid_attributes
        }.not_to change(Survivor, :count)
      end

      it 'returns unprocessable entity status' do
        post '/api/v1/survivors', params: invalid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        post '/api/v1/survivors', params: invalid_attributes

        expect(response.parsed_body['errors']).to be_present
      end
    end

    context 'with missing parameters' do
      it 'returns unprocessable entity status' do
        post '/api/v1/survivors', params: {}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['error']).to eq("param is missing or the value is empty or invalid: survivor")
      end
    end
  end
end
