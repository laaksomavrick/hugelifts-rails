# frozen_string_literal: true

class DatabaseConfig
  attr_reader :host, :database, :username, :password

  def initialize
    @host = ActiveRecord::Base.connection_db_config.host
    @database = ActiveRecord::Base.connection_db_config.database
    @username = ActiveRecord::Base.connection_db_config.configuration_hash[:username]
    @password = ActiveRecord::Base.connection_db_config.configuration_hash[:password]
  end
end
