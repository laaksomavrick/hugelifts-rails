# frozen_string_literal: true

class DigitalOceanSpacesConfig
  attr_reader :endpoint, :bucket_name, :access_key_id, :secret_access_key, :region

  def initialize
    @endpoint = ENV.fetch('DIGITAL_OCEAN_SPACES_SERVICE_URL') do
      Rails.application.credentials.do.spaces.service_url
    end
    @bucket_name = ENV.fetch('DIGITAL_OCEAN_SPACES_BUCKET_NAME') do
      Rails.application.credentials.do.spaces.bucket_name
    end
    @access_key_id = ENV.fetch('DIGITAL_OCEAN_SPACES_ACCESS_KEY') { Rails.application.credentials.do.spaces.access_key }
    @secret_access_key = ENV.fetch('DIGITAL_OCEAN_SPACES_SECRET_KEY') do
      Rails.application.credentials.do.spaces.secret_key
    end
    @region = 'us-east-1'
  end
end
