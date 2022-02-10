
namespace :posts do
  desc 'Enchances the social media posts'
  task enchance: :environment do
    EnchanceJob.perform_now
  end

  task disseminate: :environment do
    categories = %w[science business inspiration health humor crypto tech]

    # want to shuffle the categories so that we don't post the same thing over and over again
    categories.shuffle.each_with_index do |category, index|
      found = false

      Airtable::Post.unpublished.each do |post|
        post.fields['Hashtags'].each do |hashtag|
          # we only want to post 1 hashtag per day
          next if found

          if hashtag == category
            processed_tags = post.fields['Hashtags'].map { |tag| "##{tag}" }
            processed_tags = processed_tags.join(' ')

            payload = {
              url: post.fields['URL'],
              text: post.fields['Text'],
              hashtags: processed_tags,
              image: post.fields['Social'][0]['url'],
              # the time converts to 8am california time
              tomorrow_date: (Date.tomorrow.to_time(:utc) + 16.hours + index.hours).iso8601
            }

            options = {
              body: payload
            }
            HTTParty.post(ENV['BUFFER_WEBHOOK'], options)

            # sets post to published so we don't use it again
            post['Published'] = true
            post.save

            found = true
          end

        end
      end
    end


  end
end
