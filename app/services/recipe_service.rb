class RecipeService
  def get_recipe(query)
    get_url("type=public&q=#{query}")
  end

  private 
  
  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
  
  def conn
    Faraday.new(url: "https://api.edamam.com/api/recipes/v2") do |faraday|
      faraday.params["app_id"] = Rails.application.credentials.edamam[:app_id]
      faraday.params["app_key"] = Rails.application.credentials.edamam[:api_key]
    end
  end
end