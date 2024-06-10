class Api::V1:TouristSitesController < ApplicationController
  def index
    country = params[:country].presence
    
    facade = GeoapifyFacade.formatted_lat_and_long(country)
  end
end