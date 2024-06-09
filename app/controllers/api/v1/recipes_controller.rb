class Api::V1::RecipesController < ApplicationController
  def index
    binding.pry
    country = params[:country].presence || random_country
    recipes = fetch_recipes(country)

    if recipes.empty?
      render json: { data: [] }, status: :not_found
    else
      render json: format_recipes(recipes), status: :ok
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
          recipe_title: recipe['recipe']['label'],
          image: recipe['recipe']['image'],
          recipe_link: recipe['recipe']['url'],
          binding.pry
        }
      }
    end
  end
end