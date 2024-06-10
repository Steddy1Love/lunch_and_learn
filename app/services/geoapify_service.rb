class GeoapifyService
  BASE_URL = "https://api.geoapify.com/v1"
  V2 = "https://api.geoapify.com/v2"

  def search(query)
    get_url("#{BASE_URL}/geocode/search?text=#{query}&format=json")
  end

  def sites(lat, long)
    get_url("#{V2}/places?bias=proximity:#{lat},#{long}&categories=tourism.sights")
  end

  private

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new do |faraday|
      faraday.params["apiKey"] = Rails.application.credentials.geoapify[:apiKey]
    end
  end
end