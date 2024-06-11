require 'rails_helper'

RSpec.describe 'User Registration API', type: :request do
  describe 'POST /api/v1/users' do
    context 'when the request is valid' do
      let(:valid_attributes) do
        {
          name: 'Odell',
          email: 'goodboy@ruffruff.com',
          password: 'treats4lyf',
          password_confirmation: 'treats4lyf'
        }
      end

      it 'creates a new user' do
        post '/api/v1/users', params: valid_attributes.to_json, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq('user')
        expect(json[:data][:id]).to be_present
        expect(json[:data][:attributes][:name]).to eq('Odell')
        expect(json[:data][:attributes][:email]).to eq('goodboy@ruffruff.com')
        expect(json[:data][:attributes][:api_key]).to be_present
      end
    end

    context 'when the email is already taken' do
      let(:valid_attributes) do
        {
          name: 'Odell',
          email: 'goodboy@ruffruff.com',
          password: 'treats4lyf',
          password_confirmation: 'treats4lyf'
        }
      end
      
      let(:invalid_attributes) do
        {
          name: 'Odell',
          email: 'goodboy@ruffruff.com',
          password: 'treats4lyf',
          password_confirmation: 'treats4lyf'
        }
      end
          
      it 'returns a validation failure message' do
        post '/api/v1/users', params: valid_attributes.to_json, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }
        post '/api/v1/users', params: invalid_attributes.to_json, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:errors]).to include('Email has already been taken')
      end
    end

    context 'when the passwords do not match' do
      let(:invalid_attributes) do
        {
          name: 'Odell',
          email: 'goodboy@ruffruff.com',
          password: 'treats4lyf',
          password_confirmation: 'wrongpassword'
        }
      end

      it 'returns a validation failure message' do
        post '/api/v1/users', params: invalid_attributes.to_json, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:errors]).to include("Password confirmation doesn't match Password")
      end
    end
  end
end