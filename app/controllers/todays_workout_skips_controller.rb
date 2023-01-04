# frozen_string_literal: true

class TodaysWorkoutSkipsController < ApplicationController
  include TodaysWorkoutProgress

  before_action :set_todays_workout_progress_session

  def update
    params = update_todays_workout_rep_params
    skipped = params[:skipped]

    set_skipped(skipped:)

    head :created
  end

  private

  def update_todays_workout_rep_params
    params.require(:todays_workout_skip).permit(:skipped)
  end
end
