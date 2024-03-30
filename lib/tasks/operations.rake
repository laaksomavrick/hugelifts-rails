# frozen_string_literal: true

require 'database_config'
require 'database_backup_uploader'

namespace :operations do
  logger = Logger.new(Rails.root.join('log/operations.log'))

  desc 'Backs up a database dump to digital ocean'
  task backup_database: :environment do
    begin
      config = DatabaseConfig.new
      host = config.host
      username = config.username
      password = config.password
      database = config.database

      logger.info "Backing up database=#{database} at host=#{host}"

      file_name = "#{Time.zone.now.strftime('%Y%m%d%H%M%S')}_#{database}.psql_dump"
      file_location = Rails.root.join(file_name)

      pg_dump_command = "PGPASSWORD='#{password}' pg_dump -d postgres://#{username}:#{password}@#{host}:5432/#{database} > #{file_location}" # rubocop:disable Layout/LineLength
      ` #{pg_dump_command} `

      file_exists = File.file?(file_location)

      raise "Cannot find database backup at #{file_location}" unless file_exists

      uploader = DatabaseBackupUploader.new(logger:)
      ok = uploader.upload(file_location, file_name)

      raise "Something went wrong uploading #{file_name}" unless ok

      # Delete the backup from disk
      File.delete(file_location)

      logger.info 'Cleaned up database backup from disk'

      logger.info "Database backup successful with filename=#{file_name}"
    end
  rescue StandardError => e
    logger.error e
  end

  desc 'Delete production.log file'
  task delete_logs: :environment do
    prod_log_location = Rails.root.join('log/production.log')
    operation_log_location = Rails.root.join('log/operations.log')
    cron_log_location = Rails.root.join('log/cron.log')

    log_locations = [prod_log_location, operation_log_location, cron_log_location]

    log_locations.each do |log_location|
      FileUtils.rm_f(log_location)
    end
  rescue StandardError => e
    logger.error e
  end
end
