class BeermappingApi

  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 60.seconds) { fetch_places_in(city) }
  end

  def self.place_with_id(id)
    Rails.cache.fetch(id, expires_in: 60.seconds) { fetch_place_with_id(id) }
  end

  private

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"

    unless response.parsed_response["bmp_locations"]
      return []
    end
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do | place |
      Place.new(place)
    end
  end

  def self.fetch_place_with_id(id)
    url = "http://beermapping.com/webservice/locquery/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(id)}"

    unless response.parsed_response["bmp_locations"]
      return []
    end
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do | place |
      Place.new(place)
    end
  end

  def self.key
    #"cd72f2c73f934ac32034074ec13d6f6d"
    raise "APIKEY env variable not defined" if ENV['APIKEY'].nil?
    ENV['APIKEY']
  end
end