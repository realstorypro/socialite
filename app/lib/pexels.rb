# frozen_string_literal: true

class Pexels
  API_URL = 'https://api.pexels.com/v1/search'

  def initialize
    # Grab up to 320 images
    @per_page = 80
    @up_to_pages = 5
  end

  def find(keyword:)
    query = {
      query: keyword,
      per_page: @per_page
    }

    headers = {
      'Authorization': ENV['PEXELS']
    }

    photos = []

    rsp = HTTParty.get(API_URL, query: query, headers: headers)
    photos.push(*rsp['photos'])

    page = 2

    while page < @up_to_pages && !rsp['next_page'].nil?
      query['page'] = page
      rsp = HTTParty.get(API_URL, query: query, headers: headers)
      photos.push(*rsp['photos'])

      page += 1
    end

    photos.sample['src']['original']
  end
end
