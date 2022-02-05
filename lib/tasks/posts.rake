
namespace :posts do
  desc 'Enchances the social media posts'
  task enchance: :environment do
    screenshot = Screenshot.new(width: 390, height: 1884)
    pexels = Pexels.new
    placid = Placid.new

    posts = Airtable::Post.unprocessed
    posts[0..5].each do |post|
      url = post.fields['URL']
      hashtag = post.fields['Hashtags'].last
      image = pexels.find(keyword: hashtag)

      generated_screenshot = screenshot.render(url: url)
      social_card = placid.generate(title: post.fields['Text'],
                                    category: hashtag,
                                    image: image)

      post['Screenshot'] = [{ url: generated_screenshot }]
      post['Social'] = [{ url: social_card }]

      post.save
    end
  end
end
