# frozen_string_literal: true

require 'digital_ocean_spaces_config'

class DatabaseBackupUploader
  def initialize(config = DigitalOceanSpacesConfig.new)
    @config = config
  end

  def upload(file_location = '', file_key = '')
    response = client.put_object(
      bucket: @config.bucket_name,
      key: "backups/#{file_key}",
      body: File.read(file_location)
    )

    false if response.etag.blank?

    true
  rescue StandardError => e
    Rails.logger.error("Something went wrong uploading file_key=#{file_key} at file_location=#{file_location}. Error=#{e}") # rubocop:disable Layout/LineLength
    false
  end

  private

  def client
    @client ||= client_factory
  end

  def client_factory
    region = @config.region
    endpoint = @config.endpoint
    access_key_id = @config.access_key_id
    secret_access_key = @config.secret_access_key

    Aws::S3::Client.new(access_key_id:, secret_access_key:, endpoint:, region:)
  end
end
