# frozen_string_literal: true

# interacts with placid api
class Placid
  API_URL = 'https://api.placid.app/api/rest/'

  TEMPLATE_MAP = {
    science: 'lgf64mzcv',
    business: 'p5dxi0hrj',
    inspiration: 'umzhty0na',
    health: '4rsc0t81g',
    humor: 'gwrnyc2gp',
    crypto: '07e3hcbpv',
    tech: 'y1v4ab6a7'
  }.freeze

  def generate(title:, category:, image:)
    template = TEMPLATE_MAP[category.to_sym]

    uri = URI("#{API_URL}#{template}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    dict = {
      "create_now": true,
      "layers": {
        "img": {
          "image": image
        },
        "title": {
          "text": title
        },
        "tag": {
          "text": "##{category}"
        }
      }
    }

    body = JSON.dump(dict)
    req =  Net::HTTP::Post.new(uri)

    req.add_field "Authorization", "Bearer #{ENV['PLACID']}"
    req.add_field "Content-Type", "application/json; charset=utf-8"
    req.body = body

    res = http.request(req)
    parsed = JSON.parse(res.body)

    parsed['image_url']
  end
end
