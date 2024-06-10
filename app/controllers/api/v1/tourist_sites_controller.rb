class Api::V1::TouristSitesController < ApplicationController
  def index
    country = params[:country].presence

    if country
      begin
        facade = GeoapifyFacade.new
        sites = facade.formatted_lat_and_long(country)
        render json: sites, status: :ok
      rescue StandardError => e
        render json: { error: 'Unable to fetch tourist sites', message: e.message}, status: :internal_server_error
      end
    else
      render json: { error: 'Country parameter is required' }, status: :bad_request
    end
  end
end