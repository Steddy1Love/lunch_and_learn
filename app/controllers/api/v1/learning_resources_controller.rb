class Api::V1::LearningResourcesController < ApplicationController
  def index
    videos = YoutubeService.search(params[:query], "short")
    images = PexelService.search(params[:query])
    country = params[:query]

    render json: {
      data: {
        id: nil,
        type: "learning_resource",
        attributes: {
          country: country,
          video: videos || {},
          images: images
        }
      }
    }
  end
end
