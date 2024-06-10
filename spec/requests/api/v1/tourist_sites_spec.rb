require 'rails_helper'

RSpec.describe 'Tourist Sites API', type: :request do
  describe 'GET /api/v1/tourist_sites', :vcr do
    context 'when country parameter is provided' do
      it 'returns tourist sites for the given country' do
        country = 'France'

        get '/api/v1/tourist_sites', params: { country: country }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data].length).to eq(10)
        expect(json[:data].first[:attributes][:name]).to be_present
        expect(json[:data].first[:attributes][:address]).to be_present
      end
    end

    context 'when country parameter is not provided' do
      it 'returns an error' do
        get '/api/v1/tourist_sites'

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:error]).to eq('Country parameter is required')
      end
    end

    context 'when no tourist sites are found', :vcr do
      it 'returns an empty data array' do
        country = 'UnknownCountry'

        get '/api/v1/tourist_sites', params: { country: country }

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data]).to eq([])
      end
    end
  end
end