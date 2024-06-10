require 'rails_helper'

RSpec.describe 'Tourist Sites API', type: :request do
  describe 'GET /api/v1/tourist_sites' do
    context 'when country parameter is provided' do
      it 'returns tourist sites for the given country' do
        geocode_data = { lat: 48.8566, lon: 2.3522 }
        allow_any_instance_of(GeocodingService).to receive(:get_coordinates).with('France').and_return(geocode_data)
        
        tourist_sites = [
          { name: 'Eiffel Tower', address: 'Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France', place_id: '51d28...' },
          { name: 'Louvre Museum', address: 'Rue de Rivoli, 75001 Paris, France', place_id: '51934...' }
        ]
        allow_any_instance_of(TouristSitesService).to receive(:get_tourist_sites).with(48.8566, 2.3522).and_return(tourist_sites)

        get '/api/v1/tourist_sites', params: { country: 'France' }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data].length).to eq(2)
        expect(json[:data].first[:attributes][:name]).to eq('Eiffel Tower')
        expect(json[:data].first[:attributes][:address]).to eq('Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France')
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

    context 'when no tourist sites are found' do
      it 'returns an empty data array' do
        allow_any_instance_of(GeocodingService).to receive(:get_coordinates).with('UnknownCountry').and_return(nil)

        get '/api/v1/tourist_sites', params: { country: 'UnknownCountry' }

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data]).to eq([])
      end
    end
  end
end