# set :application, "staging.cx-iq.com"
set :application, "aai_ror_staging.amplifiedanalytics.com"
#set :repository,  "https://jetcharter.unfuddle.com/svn/jetcharter_dm/trunk/web"
# Use Git source control
set :scm, :git
set :repository, "git@github.com:piplzchoice/cx-iq.git"
#set :repository, "https://martynasp@github.com/dmitryv/aai_home"

# For staging, we will deploy from integration branch for now
# in the future, this should be master, and integration should 
# be tested against a development / CI system.
# Please don't change this without a good reason.  Instead, 
# merge your feature branch into the integration branch.
# If you must change it, please don't commit the change to git :) 
# CJS 120212
set :branch, "staging"


set :user, "staging"
set :deploy_to, "/home/#{user}/#{application}"
set :use_sudo, false
set :rails_env,      "staging"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"


#set :scm, :subversion
set :deploy_via, :remote_cache

role :app, '184.106.208.47'
role :web, '184.106.208.47'
role :dj,  '184.106.208.47'
# role :ae,  '184.106.228.242'
role :db,  '184.106.208.47',  :primary => true

after "deploy:update_code", 'deploy:symlink_files'
after "deploy:update_code", 'deploy:symlink_dj_files'
after "deploy:update_code", 'deploy:symlink_index'

#after "deploy:update_code", 'deploy:reset_database'


after "deploy:symlink", "deploy:update_crontab"

namespace :deploy do

  task :symlink_files do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/reports #{release_path}/public/reports"    
  end

#  task :reset_database do
#    run "cd #{release_path}; rake sass:update"
#  end

#  task :reset_database do
#    run "cd #{release_path}; rake RAILS_ENV=staging db:drop db:create db:migrate db:fixtures:load"
#  end

  task :symlink_dj_files, :roles => [:dj] do
    run "ln -nfs #{shared_path}/config/delayed_job.rb #{release_path}/config/delayed_job.rb"
  end

  desc "Update the crontab file"
  task :update_crontab, :roles => :dj do
    run "cd #{release_path} && whenever --load-file #{release_path}/config/app_schedule_staging.rb --update-crontab #{application}"
  end


  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => [:app, :ae], :except => { :no_release => true } do
    # "deleting Gemfile as passenger doesn't use it"
    run "cd #{release_path} && rm ./Gemfile && rm ./Gemfile.lock"
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "symlinks index folder"
  task :symlink_index, :roles => :app do
    run "ln -nfs #{shared_path}/index #{release_path}/index"
  end
end
