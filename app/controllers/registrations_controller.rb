# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  def create
    if FeatureFlags.user_signup_enabled? == false
      flash[:alert] = t('registrations.create.disabled')
      redirect_to new_user_registration_path
    else
      super
    end
  end
end
