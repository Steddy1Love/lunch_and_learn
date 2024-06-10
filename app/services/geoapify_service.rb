class GeoapifyService
  def self.search(query)
    get_url("text=#{query}&format=json")
  end

  def self.sites(lat,long)
    get_url("bias=proximity:#{lat},#{long}&categories=tourism.sights")
  end
  
  private
  
  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: "https://api.geoapify.com/v1/geocode/search") do |faraday|
      faraday.params["api_key"] = Rails.application.credentials.geoapify[:apiKey]
    end
  end
end