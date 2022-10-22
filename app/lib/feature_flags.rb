# frozen_string_literal: true

module FeatureFlags
  class << self
    def user_signup_enabled?
      ENV.fetch('FEATURE_FLAGS_USER_SIGNUPS') { Rails.configuration.feature_flags[:user_signups] }
    end
  end
end
