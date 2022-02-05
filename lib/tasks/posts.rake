
namespace :posts do
  desc 'Enchances the social media posts'
  task enchance: :environment do
    EnchanceJob.perform_now
  end
end
