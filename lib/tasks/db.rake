namespace :db do
  desc "Sends out product reviews update notifications"
  task :send_review_updates => :environment do |rake_task|
    ReviewUpdate.send_updates
  end
end