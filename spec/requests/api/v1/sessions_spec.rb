require 'rails_helper'

RSpec.describe 'User Authentication API', type: :request do
  before do
    @user = User.create!(
      name: 'Odell',
      email: 'goodboy@ruffruff.com',
      password: 'treats4lyf',
      password_confirmation: 'treats4lyf',
      api_key: SecureRandom.hex(24)
    )
  end

  describe 'POST /api/v1/sessions' do
    let(:valid_credentials) do
      {
        email: 'goodboy@ruffruff.com',
        password: 'treats4lyf'
    }.to_json
    end

    let(:invalid_credentials) do
      {
        email: 'goodboy@ruffruff.com',
        password: 'wrongpassword'
    }.to_json
    end

    context 'when the request is valid' do
      before { post '/api/v1/sessions', params: valid_credentials, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' } }

      it 'authenticates the user' do
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:attributes][:name]).to eq(@user.name)
        expect(json[:data][:attributes][:email]).to eq(@user.email)
        expect(json[:data][:attributes][:api_key]).to be_present
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/sessions', params: invalid_credentials, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' } }

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:error]).to eq('Invalid email or password')
      end
    end
  end
end