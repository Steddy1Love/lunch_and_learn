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

  let!(:user) { User.create!(name: 'Test User', email: 'test@example.com', password: 'password123', password_confirmation: 'password123', api_key: 'jgn983hy48thw9begh98h4539h4') }
  let!(:favorite1) { user.favorites.create(recipe_title: 'Recipe: Egyptian Tomato Soup', recipe_link: 'http://www.thekitchn.com/recipe-egyptian-tomato-soup-weeknight....', country: 'egypt') }
  let!(:favorite2) { user.favorites.create(recipe_title: 'Crab Fried Rice (Khaao Pad Bpu)', recipe_link: 'https://www.tastingtable.com/.....', country: 'thailand') }
  let(:api_key) { user.api_key }

  describe 'GET /api/v1/favorites' do
    context 'when the api_key is valid' do
      before { get '/api/v1/favorites', params: { api_key: api_key } }

      it 'returns all favorited recipes' do
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data].length).to eq(2)
        expect(json[:data][0][:attributes][:recipe_title]).to eq('Recipe: Egyptian Tomato Soup')
        expect(json[:data][0][:attributes][:recipe_link]).to eq('http://www.thekitchn.com/recipe-egyptian-tomato-soup-weeknight....')
        expect(json[:data][0][:attributes][:country]).to eq('egypt')
        expect(json[:data][1][:attributes][:recipe_title]).to eq('Crab Fried Rice (Khaao Pad Bpu)')
        expect(json[:data][1][:attributes][:recipe_link]).to eq('https://www.tastingtable.com/.....')
        expect(json[:data][1][:attributes][:country]).to eq('thailand')
      end
    end

    context 'when the api_key is invalid' do
      before { get '/api/v1/favorites', params: { api_key: 'invalid_key' }, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' } }

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:error]).to eq('Invalid API key')
      end
    end

    context 'when the user has no favorites' do
      let!(:empty_user) { User.create(name: 'Empty User', email: 'empty@example.com', password: 'password123', password_confirmation: 'password123', api_key: 'jgn983hy48thw9begh98h4539h5') }

      before { get '/api/v1/favorites', params: { api_key: empty_user.api_key }, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' } }

      it 'returns an empty array' do
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data]).to eq([])
      end
    end
  end
end