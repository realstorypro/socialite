# frozen_string_literal: true

# Enhances the posts in the airtable feed
class EnchanceJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    screenshot = Screenshot.new(width: 390, height: 1884)
    pexels = Pexels.new
    placid = Placid.new

    posts = Airtable::Post.unprocessed

    # we want to process no more then 20 posts per job
    # to avoid the rate limit errors
    posts[0..20].each do |post|
      url = post.fields['URL']
      hashtag = post.fields['Hashtags'].last
      image = pexels.find(keyword: hashtag)

      generated_screenshot = screenshot.render(url: url)
      social_card = placid.generate(title: post.fields['Text'],
                                    category: hashtag,
                                    image: image)

      post['Screenshot'] = [{ url: generated_screenshot }] if generated_screenshot
      post['Social'] = [{ url: social_card }]
      post['Processed'] = true

      post.save
    end
  end
end
