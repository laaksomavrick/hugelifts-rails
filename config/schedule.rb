# frozen_string_literal: true

# https://stackoverflow.com/questions/38838937/whenever-gem-failed-to-load-command-rake
ENV.each { |k, v| env(k, v) }

set :environment, ENV.fetch('RAILS_ENV', nil)
set :output, "#{path}/log/cron.log"

every 1.day, at: '12:00 am' do
  rake 'operations:backup_database'
end

every 1.week, at: '12:00 am' do
  rake 'db:sessions:trim'
end
