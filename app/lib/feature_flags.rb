# frozen_string_literal: true

module FeatureFlags
  class << self
    def user_signup_enabled?
      Rails.configuration.feature_flags[:user_signups]
    end
  end
end
