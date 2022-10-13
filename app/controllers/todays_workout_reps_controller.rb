# frozen_string_literal: true

class TodaysWorkoutRepsController < ApplicationController
  include TodaysWorkoutProgress

  before_action :set_todays_workout_progress_session

  def update
    exercise_id = params[:id]
    params = update_todays_workout_rep_params
    ordinal = params[:ordinal]
    reps = params[:rep_count].to_i

    set_progress(exercise_id:, ordinal:, reps:)

    head :created
  end

  private

  def update_todays_workout_rep_params
    params.require(:todays_workout_rep).permit(:ordinal, :rep_count)
  end
end
