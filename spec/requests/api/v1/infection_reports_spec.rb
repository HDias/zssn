require 'rails_helper'

RSpec.describe Api::V1::InfectionReportsController, type: :request do
  let(:valid_survivor) { create(:survivor, infected: false) }
  let(:reporter) { create(:survivor, infected: false) }
  let(:reported) { create(:survivor, infected: false) }
  let(:infected_survivor) { create(:survivor, infected: true) }

  describe "#create" do
    let(:serialized_keys) { %w[id reporter reported reporter_latitude reporter_longitude] }

    context "with valid parameters" do
      let(:valid_params) do
        {
          infection_report: {
            reporter_id: reporter.id,
            reported_id: reported.id,
            reporter_latitude: FFaker::Geolocation.lat,
            reporter_longitude: FFaker::Geolocation.lng
          }
        }
      end

      it "creates a new infection report" do
        expect {
          post "/api/v1/infection_reports", params: valid_params
        }.to change(InfectionReport, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it "marks survivor as infected after 3 reports" do
        2.times do
          create(:infection_report, reporter: create(:survivor), reported: reported)
        end

        post "/api/v1/infection_reports", params: valid_params

        expect(response.parsed_body["reported"]["infected"]).to be true
        expect(response.parsed_body["reported"]["infection_reports"]).to eq 3
      end
    end

    context "with invalid parameters" do
      it "returns error when reporter reports themselves" do
        params = {
          infection_report: {
            reporter_id: reporter.id,
            reported_id: reporter.id,
            reporter_latitude: FFaker::Geolocation.lat,
            reporter_longitude: FFaker::Geolocation.lng
          }
        }

        post "/api/v1/infection_reports", params: params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body["errors"]).to include("Reported can't report yourself")
      end

      it "returns error when reporter is infected" do
        params = {
          infection_report: {
            reporter_id: infected_survivor.id,
            reported_id: reported.id,
            reporter_latitude: FFaker::Geolocation.lat,
            reporter_longitude: FFaker::Geolocation.lng
          }
        }

        post "/api/v1/infection_reports", params: params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body["errors"]).to include("Reporter infected survivors cannot report others")
      end

      it "returns error when reporting same person twice" do
        create(:infection_report, reporter: reporter, reported: reported)

        params = {
          infection_report: {
            reporter_id: reporter.id,
            reported_id: reported.id,
            reporter_latitude: FFaker::Geolocation.lat,
            reporter_longitude: FFaker::Geolocation.lng
          }
        }

        post "/api/v1/infection_reports", params: params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body["errors"]).to include("Reported already reported this survivor")
      end

      it "returns error with invalid latitude" do
        params = {
          infection_report: {
            reporter_id: reporter.id,
            reported_id: reported.id,
            reporter_latitude: 91,
            reporter_longitude: FFaker::Geolocation.lng
          }
        }

        post "/api/v1/infection_reports", params: params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body["errors"]).to include("Reporter latitude must be less than or equal to 90")
      end

      it "returns error with invalid longitude" do
        params = {
          infection_report: {
            reporter_id: reporter.id,
            reported_id: reported.id,
            reporter_latitude: FFaker::Geolocation.lat,
            reporter_longitude: 181
          }
        }

        post "/api/v1/infection_reports", params: params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body["errors"]).to include("Reporter longitude must be less than or equal to 180")
      end
    end
  end
end
