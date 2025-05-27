require 'rails_helper'

RSpec.describe 'ApplicationController', type: :request do
  describe 'rescue_from ActionController::RoutingError' do
    it 'returns 404 status with error message' do
      get '/non_existent_route', headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:not_found)
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body["error"]).to eq("Not Found")
    end
  end
end
