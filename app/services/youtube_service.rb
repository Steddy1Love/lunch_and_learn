class YoutubeService
  def search(query_keywords, video_duration)
    url = 'search'
    params = {
      part: 'snippet',
      maxResults: 1,
      order: 'relevance',
      type: 'video',
      videoEmbeddable: true,
      q: "#{query_keywords}",
      videoDuration: video_duration
    }

    response = call_api(url, params)
    parse_video_response(response)
  end

  private

  def call_api(url, params = {})
    response = connection.get(url) do |request|
      request.params = params
      request.params[:key] = Rails.application.credentials.youtube[:api_key]
    end

    JSON.parse(response.body, symbolize_names: true)
  end

  def connection
    Faraday.new('https://www.googleapis.com/youtube/v3')
  end

  def parse_video_response(response)
    if response
      binding.pry
      response[:items].first
      {
        title: video[:snippet][:title],
        youtube_video_id: video[:id][:videoId]
      }
    else
      {}
    end 
  end
end