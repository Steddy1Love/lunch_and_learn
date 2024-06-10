class GeoapifyService
  def search(query)
    get_url("text=#{query}&format=json")
  end

  def sites(lat,long)
    get_url("bias=proximity:#{lat},#{long}&categories=tourism.sights")
  end
  
  def get_url(url)
    response = conn.get(url)
    data = JSON.parse(response.body, symbolize_names: true)
    binding.pry
  end

  def conn
    Faraday.new(url: "https://api.geoapify.com/v1/geocode/search") do |faraday|
      faraday.params["api_key"] = Rails.application.credentials.geoapify[:apiKey]
    end
  end
end