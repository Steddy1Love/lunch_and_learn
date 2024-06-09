class Api::V1::RecipeController < ApplicationController

  def index
    country = params[:country].presence || random_country
    recipes = fetch_recipes(country)

    if recipes.empty?
      render json: { data: [] }
    else
      render json: format_recipes(recipes)
    end
  end

  private

  def random_country
    RestCountriesService.new.random_country_name
  end

  def fetch_recipes(country)
    service = RecipeService.new
    recipes = service.get_recipe(country)[:hits]
    recipes.select { |recipe| recipe['recipe'].present? }
  end

  def format_recipes(recipes)
    recipes.map do |recipe|
      {
        id: recipe['recipe']['uri'],
        type: 'recipe',
        attributes: {
          label: recipe['recipe']['label'],
          image: recipe['recipe']['image'],
          url: recipe['recipe']['url'],
          ingredients: recipe['recipe']['ingredientLines'],
          calories: recipe['recipe']['calories'],
          totalTime: recipe['recipe']['totalTime']
        }
      }
    end
  end
end