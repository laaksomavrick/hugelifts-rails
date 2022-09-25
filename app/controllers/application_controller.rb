# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :authenticate_user!

  # rubocop:disable Rails/LexicallyScopedActionFilter
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  # rubocop:enable Rails/LexicallyScopedActionFilter

  # Here so Rubymine stops complaining
  def current_user # rubocop:disable Lint/UselessMethodDefinition
    super
  end

  def authenticate_user! # rubocop:disable Lint/UselessMethodDefinition
    super
  end
end
