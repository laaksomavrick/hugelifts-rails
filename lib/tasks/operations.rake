# frozen_string_literal: true

require 'database_config'

namespace :operations do
  desc 'Backs up a database dump to digital ocean'
  task backup_database: :environment do
    Rails.logger.info 'Attempting to backup database'

    config = DatabaseConfig.new
    host = config.host
    username = config.username
    password = config.password
    database = config.database

    Rails.logger.info "Backing up database=#{database} at host=#{host}"

    file_location = "#{Rails.root}/#{Time.zone.now.strftime('%Y%m%d%H%M%S')}_#{database}.psql_dump"

    Rails.logger.info "Sending backup to volume=#{file_location}"

    pg_dump_command = "PGPASSWORD='#{password}' pg_dump -d postgres://#{username}:#{password}@#{host}:5432/#{database} > #{file_location}"
    ` #{pg_dump_command} `

    Rails.logger.info "Wrote pg_dump output to #{file_location}"

    file_exists = File.file?(file_location)

    if file_exists == false
      Rails.logger.error "Cannot find database backup at #{file_location}"
      return
    end

    Rails.logger.info "Found database backup at #{file_location}"

    # Upload it to digital ocean spaces
    # TODO

    # Delete the backup from disk
    # TODO
    # todo: consider how to rotate in digital ocean spaces

    # TODO: use whenever to set up cron for every day/week/whatever
  end
end
