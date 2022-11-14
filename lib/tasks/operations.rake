# frozen_string_literal: true

require 'database_config'

namespace :operations do

  desc 'Backs up a database dump to digital ocean'
  task backup_database: :environment do
    Rails.logger.info 'Attempting to backup database'

    # Get the config
    config = DatabaseConfig.new
    host = config.host
    username = config.username
    password = config.password
    database = config.database

    # Build the command to run
    filename = "#{Rails.root}/tmp/backup/#{Time.zone.now.strftime('%Y%m%d%H%M%S')}_#{database}.psql_dump"
    pg_cmd = "PGPASSWORD='#{password}' pg_dump -F c -v -h '#{host}' -U '#{username}' -f '#{filename}' #{database}"
    docker_cmd = "docker exec app #{pg_cmd}"

    # Exec
    exec docker_cmd

    Rails.logger.info "Database backed up to #{filename}"

    # Upload it to digital ocean spaces

    # Set up cron for every day/week/whatever
  end
end
