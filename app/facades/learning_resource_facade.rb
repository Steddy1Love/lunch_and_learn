class LearningResourceFacade
  def call_api(country)
    service1 = YoutubeService.new
    video = service1.search(country, "short")
    
    service2 = PexelService.new
    images = service2.search(country)
    
    self.format_data(country, videos, images)
  end

  def self.format_data(country, video_data, image_data)
    binding.pry
     {
        id: nil,
        type: "learning_resource",
        attributes: {
          country: country,
          video: video_data || {},
          images: image_data || []
        }
      }
  end
end