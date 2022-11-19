# frozen_string_literal: true

require 'database_config'
require 'database_backup_uploader'

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

    file_name = "#{database}_backup"
    file_location = "#{Rails.root}/#{file_name}.psql_dump"

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

    uploader = DatabaseBackupUploader.new
    ok = uploader.upload(file_location, file_name)

    if ok == false
      Rails.logger.error "Something went wrong uploading #{file_name}"
      return
    end

    Rails.logger.info 'Uploaded database backup'

    # Delete the backup from disk
    File.delete(file_location)

    Rails.logger.info 'Cleaned up database backup from disk'

    Rails.logger.info 'Database backup successful, exiting...'

    # TODO: use whenever to set up cron for every day/week/whatever
  end
end
