set :application, "amplifiedanalytics.com"
#set :repository,  "https://jetcharter.unfuddle.com/svn/jetcharter_dm/trunk/web"
# Use Git source control
set :scm, :git
set :repository, "git@github.com:piplzchoice/cx-iq.git"

# Production deploys should ALWAYS come from master branch.
# Please don't change this without a really good reason.
# Instead, merge integration to master, if the code there is
# tested and ready for production deployment.
# CJS 120212
set :branch, "master"


set :user, "production"
set :deploy_to, "/home/#{user}/#{application}"
set :use_sudo, false
set :rails_env,      "production"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"


#set :scm, :subversion
set :deploy_via, :remote_cache

role :app, '184.106.208.47'
role :web, '184.106.208.47'
role :dj,  '184.106.208.47'
role :ae,  '184.106.228.242'
role :db,  '184.106.208.47',  :primary => true

after "deploy:update_code", 'deploy:symlink_files'
after "deploy:update_code", 'deploy:symlink_dj_files'
after "deploy:update_code", 'deploy:symlink_index'

#after "deploy:symlink", "deploy:update_db_crontab"
#after "deploy:symlink", "deploy:update_app_crontab"

after "deploy:symlink", "deploy:update_crontab"

namespace :deploy do

#  desc "Update the crontab file on DJ server"
#  task :update_db_crontab, :roles => [:dj] do
#    run "cd #{release_path} && whenever --load-file #{release_path}/config/dj_schedule.rb --update-crontab #{application}"
#  end
#
#  desc "Update the crontab file on Data collector server"
#  task :update_app_crontab, :roles => [:app] do
#    run "cd #{release_path} && whenever --load-file #{release_path}/config/app_schedule.rb --update-crontab #{application}"
#  end

  task :symlink_files do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/reports #{release_path}/public/reports"
  end

  task :symlink_dj_files, :roles => [:dj] do
    run "ln -nfs #{shared_path}/config/delayed_job.rb #{release_path}/config/delayed_job.rb"
  end

  desc "Update the crontab file"
  task :update_crontab, :roles => :dj do
    run "cd #{release_path} && whenever --load-file #{release_path}/config/app_schedule.rb --update-crontab #{application}"
  end

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => [:ae, :app], :except => { :no_release => true } do
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
