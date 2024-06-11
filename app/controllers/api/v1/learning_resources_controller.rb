class Api::V1::LearningResourcesController < ApplicationController
  def index
    country = params[:query]
    
    facade = LearningResourceFacade.new

    resources = facade.call_api(country)
    if resources.nil?
      render json: {
          data: {
            id: nil,
            type: 'learning_resource',
            attributes: {
              country: country,
              video: {},
              images: []
            }
          }
        }, status: :ok
    else
      render json:  resources, status: :ok
    end
  end
end
