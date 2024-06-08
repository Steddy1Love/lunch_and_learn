class RecipeSerivce
  def get_recipe(region)
    get_url("cuisineType=#{region}")
  end
  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
  
  def conn
    Faraday.new(url: "https://api.edamam.com/api/recipes/v2") do |faraday|
      faraday.params["app_id"] = 
      faraday.params["app_key"] = 
    end
  end
end