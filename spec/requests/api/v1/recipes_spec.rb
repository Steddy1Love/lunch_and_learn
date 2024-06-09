require 'rails_helper'

RSpec.describe 'Recipes API', type: :request do
  describe 'GET /api/v1/recipes' do
    context 'when country is provided' do
      it 'returns recipes for the given country' do
        allow_any_instance_of(RecipeService).to receive(:get_recipe).and_return({ hits: [{ 'recipe' => { 'uri' => 'http://example.com', 'label' => 'Recipe Title', 'image' => 'http://example.com/image.jpg', 'url' => 'http://example.com/recipe' } }] })

        get '/api/v1/recipes', params: { country: 'Italy' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response).to be_an(Array)
        expect(json_response).not_to be_empty
        binding.pry
        expect(json_response.first[:type]).to eq('recipe')
        expect(json_response.first[:attributes][:recipe_title]).to eq('Recipe Title')
        expect(json_response.first[:attributes][:image]).to eq('http://example.com/image.jpg')
        expect(json_response.first[:attributes][:recipe_link]).to eq('http://example.com/recipe')
      end
    end

    context 'when country is not provided' do
      it 'returns recipes for a random country' do
        allow_any_instance_of(RestCountriesService).to receive(:random_country_name).and_return('Italy')
        allow_any_instance_of(RecipeService).to receive(:get_recipe).and_return({ hits: [{ 'recipe' => { 'uri' => 'http://example.com', 'label' => 'Recipe Title', 'image' => 'http://example.com/image.jpg', 'url' => 'http://example.com/recipe' } }] })

        get '/api/v1/recipes'

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response).to be_an(Array)
        expect(json_response).not_to be_empty
        expect(json_response.first[:type]).to eq('recipe')
        expect(json_response.first[:attributes][:recipe_title]).to eq('Recipe Title')
        expect(json_response.first[:attributes][:image]).to eq('http://example.com/image.jpg')
        expect(json_response.first[:attributes][:recipe_link]).to eq('http://example.com/recipe')
      end
    end

    context 'when no recipes are found' do
      it 'returns an empty array' do
        allow_any_instance_of(RecipeService).to receive(:get_recipe).and_return({ hits: [] })

        get '/api/v1/recipes', params: { country: 'InvalidCountry' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:data]).to eq([])
      end
    end
  end
end
