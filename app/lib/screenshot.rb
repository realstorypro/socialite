# frozen_string_literal: true

class Screenshot
  API_URL = 'https://shot.screenshotapi.net/screenshot'

  def initialize(width:, height:)
    @width = width
    @height = height
  end

  def render(url:)
    query = {
      token: ENV['SCREENSHOT'],
      url: url,
      width: @width,
      height: @height,
      output: 'json',
      file_type: 'png',
      wait_for_event: 'load',
      block_ads: 'true',
      no_cookie_banners: 'true'
    }

    rsp = HTTParty.get(API_URL, query: query)
    rsp.parsed_response['screenshot']
  end
end
