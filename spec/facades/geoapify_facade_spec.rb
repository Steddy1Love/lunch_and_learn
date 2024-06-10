require 'rails_helper'

RSpec.describe GeoapifyFacade do
  describe '.formatted_lat_and_long', :vcr do
    it 'returns formatted tourist sites data' do
      country = 'France'

      result = GeoapifyFacade.formatted_lat_and_long(country)

      expect(result.length).to eq(10)
      expect(result.first[:attributes][:name]).to be_present
      expect(result.first[:attributes][:address]).to be_present
    end
  end
end