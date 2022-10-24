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

  protected

  def after_sign_up_path_for(resource)
    todays_workout_index_path
  end
end
