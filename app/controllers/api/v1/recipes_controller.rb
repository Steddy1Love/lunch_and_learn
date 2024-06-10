class Api::V1::RecipesController < ApplicationController
  def index
    country = params[:country].presence 
    recipes = fetch_recipes(country)

    if recipes.empty?
      render json: { data: [] }, status: :ok
    else
      render json: format_recipes(recipes), status: :ok
    end
  end

  private

  # def random_country
  #   RestCountriesService.new.random_country_name
  # end

  def fetch_recipes(country)
    service = RecipeService.new
    recipes = service.get_recipe(country)[:hits]
    recipes.select { |recipe| recipe['recipe'].present? }
  end

  def format_recipes(recipes)
    recipes.map do |recipe|
      {
        id: nil,
        type: 'recipe',
        attributes: {
          recipe_title: recipe['recipe']['label'],
          image: recipe['recipe']['image'],
          recipe_link: recipe['recipe']['url']
          
        }
      }
    end
  end
end