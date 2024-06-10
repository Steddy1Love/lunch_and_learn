require 'rails_helper'

RSpec.describe GeoapifyService do
  describe '.search', :vcr do
    it 'returns latitude and longitude for a given country' do
      country = 'France'
      service = GeoapifyService.new
      response = service.search(country)

      expect(response).to be_a(Hash)
      expect(response[:results]).to be_an(Array)
      expect(response[:results].first).to have_key(:lat)
      expect(response[:results].first).to have_key(:lon)
    end
  end

  describe '.sites', :vcr do
    it 'returns tourist sites for given latitude and longitude' do
      lat = 48.8566
      lon = 2.3522
      service = GeoapifyService.new
      response = service.sites(lat, lon)
      expect(response).to be_a(Hash)
      expect(response[:features]).to be_an(Array)
      expect(response[:features].first[:properties]).to have_key(:name)
      expect(response[:features].first[:properties]).to have_key(:formatted)
      expect(response[:features].first[:properties]).to have_key(:place_id)
    end
  end
end