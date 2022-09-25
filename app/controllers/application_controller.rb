# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :authenticate_user!

  # Pundit development tooling for assuring authorize is called in controller methods
  after_action :verify_authorized, except: :index, if: -> { Rails.env.development? }
  after_action :verify_policy_scoped, only: :index, if: -> { Rails.env.development? }

  # Here so Rubymine stops complaining
  def current_user # rubocop:disable Lint/UselessMethodDefinition
    super
  end

  def authenticate_user! # rubocop:disable Lint/UselessMethodDefinition
    super
  end
end
