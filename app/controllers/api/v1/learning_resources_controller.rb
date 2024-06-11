class Api::V1::LearningResourcesController < ApplicationController
  def index
    country = params[:query]
    
    facade = LearningResourceFacade.new

    resources = facade.call_api(country)
    
    render json: { data: resources }
  end
end
