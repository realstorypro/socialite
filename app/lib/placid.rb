# frozen_string_literal: true

# interacts with placid api
class Placid
  API = 'https://api.placid.app/u/'
  TEMPLATE_MAP = {
    science: 'lgf64mzcv',
    business: 'p5dxi0hrj'
  }.freeze

  def generate(title:, category:, image:)
    template = TEMPLATE_MAP[category.to_sym]
    puts template
  end
end