# frozen_string_literal: true

# interacts with placid api
class Placid
  API_URL = 'https://api.placid.app/u/'
  TEMPLATE_MAP = {
    science: 'lgf64mzcv',
    business: 'p5dxi0hrj'
  }.freeze

  def generate(title:, category:, image:)
    template = TEMPLATE_MAP[category.to_sym]
    query = {
      "img[image]": image,
      "title[text]": title,
      "tag[text]": category
    }

    signature = OpenSSL::HMAC.hexdigest("SHA256", ENV['PLACID'], "#{CGI.unescape(query.to_query)}")

    new_query = {
      "img[image]": image,
      "title[text]": title,
      "tag[text]": category,
      "s": signature
    }

    rsp = HTTParty.get(API_URL + template, query: new_query)

    byebug
  end
end