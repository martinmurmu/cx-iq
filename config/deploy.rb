set :stages, %w(production staging)
set :default_stage, 'production'
set :keep_releases, 10
after "deploy:update_code", "deploy:cleanup"

after "deploy:update_code", "delayed_job:restart"

require 'capistrano/ext/multistage'

Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

task :after_update_code, :roles => :app do  
  if ENV['build_gems'] and ENV['build_gems'] == '1'
    run "rake -f #{release_path}/Rakefile gems:refresh_specs"
    run "rake -f #{release_path}/Rakefile gems:build"
  end
end

namespace :delayed_job do 
    desc "Restart the delayed_job process"
    task :restart, :roles => :app do
      #DELAYED JOB SCRIPT IS RUNNING WITH ROOT PRIVELEGES
      #SHOULD BE RESTARTED BY ROOT
#        run "cd #{current_path}; RAILS_ENV=#{rails_env} script/delayed_job restart"
         #killing process
         #process will be restarted autmatically, by server
#         run "ps ax | grep 'jobs:work' | grep -v grep | awk '{print $1}' | xargs kill"
    end
end

#require 'hoptoad_notifier/capistrano'
