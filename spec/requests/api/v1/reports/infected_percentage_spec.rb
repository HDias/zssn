# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Reports::InfectedPercentageController, type: :request do
  describe '#index' do
    context 'when there are 2 survivors' do
      let!(:infected_survivor) { create(:survivor, infected: true) }
      let!(:non_infected_survivor) { create(:survivor, infected: false) }

      before do
        get '/api/v1/reports/infected_percentage'
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the infected percentage' do
        json_response = JSON.parse(response.body)
        expect(json_response['percentage']).to eq(50.0)
      end
    end

    context 'when there are no survivors' do
      before do
        get '/api/v1/reports/infected_percentage'
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns 0 percentage' do
        json_response = JSON.parse(response.body)
        expect(json_response['percentage']).to eq(0.0)
      end
    end

    context 'when all survivors are infected' do
      let!(:infected_survivor1) { create(:survivor, infected: true) }
      let!(:infected_survivor2) { create(:survivor, infected: true) }
      let!(:infected_survivor3) { create(:survivor, infected: true) }

      before do
        get '/api/v1/reports/infected_percentage'
      end

      it 'returns 100 percentage' do
        json_response = JSON.parse(response.body)
        expect(json_response['percentage']).to eq(100.0)
      end
    end

    context 'when no survivors are infected' do
      let!(:non_infected_survivor1) { create(:survivor, infected: false) }
      let!(:non_infected_survivor2) { create(:survivor, infected: false) }
      let!(:non_infected_survivor3) { create(:survivor, infected: false) }
      let!(:non_infected_survivor4) { create(:survivor, infected: false) }

      before do
        get '/api/v1/reports/infected_percentage'
      end

      it 'returns 0 percentage' do
        json_response = JSON.parse(response.body)
        expect(json_response['percentage']).to eq(0.0)
      end
    end
  end
end
