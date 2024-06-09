# spec/requests/recipes_spec.rb
require 'rails_helper'

RSpec.describe 'Recipes API', type: :request do
  describe 'GET /recipes' do
    context 'when country is provided' do
      it 'returns recipes for the given country' do
        get '/recipes', params: { country: 'Italy' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response).to be_an(Array)
        expect(json_response).not_to be_empty
        json_response.each do |recipe|
          expect(recipe).to have_key(:id)
          expect(recipe).to have_key(:type)
          expect(recipe[:attributes]).to have_key(:label)
          expect(recipe[:attributes]).to have_key(:image)
          expect(recipe[:attributes]).to have_key(:url)
          expect(recipe[:attributes]).to have_key(:ingredients)
          expect(recipe[:attributes]).to have_key(:calories)
          expect(recipe[:attributes]).to have_key(:totalTime)
        end
      end
    end

    context 'when country is not provided' do
      it 'returns recipes for a random country' do
        allow_any_instance_of(RestCountriesService).to receive(:random_country_name).and_return('Italy')
        get '/recipes'

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response).to be_an(Array)
        expect(json_response).not_to be_empty
        json_response.each do |recipe|
          expect(recipe).to have_key(:id)
          expect(recipe).to have_key(:type)
          expect(recipe[:attributes]).to have_key(:label)
          expect(recipe[:attributes]).to have_key(:image)
          expect(recipe[:attributes]).to have_key(:url)
          expect(recipe[:attributes]).to have_key(:ingredients)
          expect(recipe[:attributes]).to have_key(:calories)
          expect(recipe[:attributes]).to have_key(:totalTime)
        end
      end
    end

    context 'when no recipes are found' do
      it 'returns an empty array' do
        allow_any_instance_of(EdamamService).to receive(:get_recipes).and_return('hits' => [])
        get '/recipes', params: { country: 'InvalidCountry' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:data]).to eq([])
      end
    end
  end
end
