class Api::V1::VideosController < ApplicationController
  def index
    videos = YoutubeService.search(params[:query], "short")
    
    render json: videos
  end
end
