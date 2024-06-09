class RestCountriesService
  def initialize
    @conn = Faraday.new(url: 'https://restcountries.com/v3.1') do |faraday|
      faraday.adapter Faraday.default_adapter
    end
  end

  def random_country_name
    response = @conn.get('/all')
    countries = JSON.parse(response.body)
    countries.sample['name']['common']
  end
end