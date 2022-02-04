# frozen_string_literal: true

class Pexels
  API_URL = 'https://api.pexels.com/v1/search'

  def initialize()
    @per_page = 80
  end

  def find(keyword:)
    query = {
      query: keyword,
      per_page: @per_page
    }

    headers = {
      'Authorization': ENV['PEXELS']
    }

    rsp = HTTParty.get(API_URL, query: query, headers: headers)

    random_photo = rsp['photos'].shuffle.last
    random_photo['src']['original']
  end
end
