class GeoapifyFacade
  def self.formatted_lat_and_long(country)
    service = GeoapifyService.new
    
    unformatted_lat_and_long = service.search(country)

    lat = unformatted_lat_and_long[:results].first[:lat]
    long = unformatted_lat_and_long[:results].first[:lon]

    sites = service.sites(lat,long)

    format_data(sites)
  end

  private

  def format_data(sites)
      data = sites[:features].first(10).map do |feature|
      {
        id: nil,
        type: "tourist_site",
        attributes: {
          name: feature[:properties][:name],
          address: feature[:properties][:formatted],
          place_id: feature[:properties][:place_id]
        }
      }
    end
  end
end