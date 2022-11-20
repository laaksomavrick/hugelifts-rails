# frozen_string_literal: true

set :output, "#{path}/log/cron.log"

every 1.day, at: '12:00 am' do
  rake 'operations:backup_database'
end
