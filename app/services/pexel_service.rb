class PexelService
  def search(query)
    get_url("query=#{query}")
  end

  def get_url(url)
    response = conn.get(url)
    data = JSON.parse(response.body, symbolize_names: true)
    return [] if data[:results].blank?

    data[:photos].first(10).map do |image|
      {
        alt_tag: image[:alt]
        url: image[:src][:original]
      }
    end
  end
  
  def conn
    Faraday.new(url: "https://api.pexels.com/v1/search") do |faraday|
      faraday.headers['Authorization'] = Rails.application.credentials.pexel[:api_key]
    end
  end
end