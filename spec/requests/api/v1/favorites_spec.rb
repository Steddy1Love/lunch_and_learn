require 'rails_helper'

RSpec.describe 'Favorites API', type: :request do
  let!(:user) do
    User.create!(
      name: 'Andy',
      email: 'cowboy@westworld.com',
      password: 'Love2ride4free',
      password_confirmation: 'Love2ride4free',
      api_key: SecureRandom.hex(24)
    )
  end

  let(:valid_attributes) do
    {
      api_key: user.api_key,
      country: 'thailand',
      recipe_link: 'https://www.tastingtable.com/.....',
      recipe_title: 'Crab Fried Rice (Khaao Pad Bpu)'
    }
  end

  let(:invalid_attributes) do
    {
      api_key: 'invalid_api_key',
      country: 'thailand',
      recipe_link: 'https://www.tastingtable.com/.....',
      recipe_title: 'Crab Fried Rice (Khaao Pad Bpu)'
    }
  end

  describe 'POST /api/v1/favorites' do
    context 'when the request is valid' do
      before { post '/api/v1/favorites', params: valid_attributes.to_json, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' } }

      it 'creates a new favorite' do
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:success]).to eq('Favorite added successfully')
      end
    end

    context 'when the api_key is invalid' do
      before { post '/api/v1/favorites', params: invalid_attributes.to_json, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' } }

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:error]).to eq('Invalid API key')
      end
    end
  end
end