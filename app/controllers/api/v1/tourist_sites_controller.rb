class Api::V1::TouristSitesController < ApplicationController
  def index
    country = params[:country]

    if country
        facade = GeoapifyFacade.new
        tourist_sites = facade.formatted_lat_and_long(country)
        
        if tourist_sites.empty?
          render json: { data: [] }, status: :not_found
        else
          render json: { data: tourist_sites }, status: :ok
        end
    else
      render json: { error: 'Country parameter is required' }, status: :bad_request
    end
  end
end