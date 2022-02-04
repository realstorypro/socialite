
namespace :posts do
  desc 'Enchances the social media posts'
  task enchance: :environment do
    screenshot = Screenshot.new(width: 390, height: 1884)
    pexels = Pexels.new
    placid = Placid.new

    posts = Airtable::Post.unprocessed
    posts[0..5].each do |post|
      url = post.fields['URL']
      hashtag =  post.fields['Hashtags'].last
      image = pexels.find(keyword: hashtag)
      social_card = placid.generate(title: post.fields["Text"],
                      category: hashtag,
                      image: image)

      byebug



      post["Screenshot"] = [{ url: screenshot.render(url: url) }]

      post.save
    end
  end
end
