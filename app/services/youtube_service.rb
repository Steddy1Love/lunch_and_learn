class YoutubeService
  def self.search(query_keywords, video_duration)
    url = 'search'
    params = {
      part: 'snippet',
      maxResults: 1,
      order: 'relevance',
      type: 'video',
      videoEmbeddable: true,
      q: "#{query_keywords} history",
      videoDuration: video_duration
    }

    response = call_api(url, params)
    parse_video_response(response)
  end

  private

  def self.call_api(url, params = {})
    response = connection.get(url) do |request|
      request.params = params
      request.params[:key] = Rails.application.credentials.google[:api_key]
    end

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.connection
    Faraday.new('https://www.googleapis.com/youtube/v3')
  end

  def parse_video_response(response)
    data = JSON.parse(response.body, symbolize_names: true)
    return if data[:items].blank?

    video = data[:items].first
    {
      title: video[:snippet][:title],
      youtube_video_id: video[:id][:videoId]
    }
  end
end