class Api::V1::FavoritesController < ApplicationController
  def create
    user = User.find_by(api_key: favorite_params[:api_key])
    if user
      favorite = user.favorites.new(
        country: favorite_params[:country],
        recipe_link: favorite_params[:recipe_link],
        recipe_title: favorite_params[:recipe_title]
      )

      if favorite.save
        render json: { success: "Favorite added successfully" }, status: :created
      else
        render json: { error: favorite.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid API key' }, status: :unauthorized
    end
  end

  def index
    user = User.find_by(api_key: params[:api_key])

    if user
      render json: FavoriteSerializer.new(user.favorites) 
    else
      render json: { error: 'Invalid API key' }, status: :unauthorized
    end
  end

  private

  def favorite_params
    params.permit(:api_key, :country, :recipe_link, :recipe_title)
  end
end