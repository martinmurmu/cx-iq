# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :cron_log, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :environment, "staging"
set :cron_log, "/home/staging/aai_ror_staging.amplifiedanalytics.com/current/log/cron_log.log"

every 2.hours do
  rake "ferret:rebuild INDEXES=product"
end

every 6.hours do
  rake "db:update_category_attribs"
end

every 1.day do
  rake "db:recalculate_cached_counters"
end