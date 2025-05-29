# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Reports::NonInfectedPercentageController, type: :request do
  describe '#index' do
    context 'when there are both infected and non-infected survivors' do
      let!(:infected_survivor) { create(:survivor, infected: true) }
      let!(:non_infected_survivor) { create(:survivor, infected: false) }

      before do
        get '/api/v1/reports/non_infected_percentage'
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the non-infected percentage' do
        json_response = JSON.parse(response.body)
        expect(json_response['percentage']).to eq(50.0)
      end
    end

    context 'when all survivors are infected' do
      let!(:infected_survivor1) { create(:survivor, infected: true) }
      let!(:infected_survivor2) { create(:survivor, infected: true) }
      let!(:infected_survivor3) { create(:survivor, infected: true) }

      before do
        get '/api/v1/reports/non_infected_percentage'
      end

      it 'returns 0% non-infected' do
        json_response = JSON.parse(response.body)
        expect(json_response['percentage']).to eq(0.0)
      end
    end

    context 'when all survivors are non-infected' do
      let!(:non_infected_survivor1) { create(:survivor, infected: false) }
      let!(:non_infected_survivor2) { create(:survivor, infected: false) }
      let!(:non_infected_survivor3) { create(:survivor, infected: false) }

      before do
        get '/api/v1/reports/non_infected_percentage'
      end

      it 'returns 100% non-infected' do
        json_response = JSON.parse(response.body)
        expect(json_response['percentage']).to eq(100.0)
      end
    end

    context 'when there are no survivors' do
      before do
        get '/api/v1/reports/non_infected_percentage'
      end

      it 'returns 0% non-infected' do
        json_response = JSON.parse(response.body)
        expect(json_response['percentage']).to eq(0.0)
      end
    end

    context 'with multiple survivors and different infection statuses' do
      let!(:infected_survivor1) { create(:survivor, infected: true) }
      let!(:infected_survivor2) { create(:survivor, infected: true) }
      let!(:non_infected_survivor1) { create(:survivor, infected: false) }
      let!(:non_infected_survivor2) { create(:survivor, infected: false) }
      let!(:non_infected_survivor3) { create(:survivor, infected: false) }

      before do
        get '/api/v1/reports/non_infected_percentage'
      end

      it 'returns the correct non-infected percentage' do
        json_response = JSON.parse(response.body)
        expect(json_response['percentage']).to eq(60.0)
      end
    end
  end
end
