require 'rails_helper'

RSpec.describe "ApiKeys", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/api_keys/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /regenerate" do
    it "returns http success" do
      get "/api_keys/regenerate"
      expect(response).to have_http_status(:success)
    end
  end

end
