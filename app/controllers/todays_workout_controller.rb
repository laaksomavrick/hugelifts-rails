# frozen_string_literal: true

class TodaysWorkoutController < ApplicationController
  include TodaysWorkoutProgress

  def index
    policy_scope(ScheduledWorkout)
    scheduled_workout = TodaysWorkoutGenerationService.new(user: current_user).call
    @todays_workout = TodaysWorkoutPresenter.new(scheduled_workout:, todays_workout_progress:)
  end

  def update
    todays_workout_id = params[:id]
    workout_results = params[:scheduled_workout_exercises]

    todays_workout = authorize ScheduledWorkout.find_by(id: todays_workout_id)
    service = TodaysWorkoutCompletionService.new(todays_workout:, workout_results:)

    ok = service.call

    if ok == false
      flash[:alert] = I18n.t('todays_workout.update.error')
    else
      # TODO: better way of doing this
      session[:todays_workout_state] = nil
      flash[:notice] = I18n.t('todays_workout.update.success')
    end

    redirect_to(todays_workout_index_path)
  end

  private

  def update_todays_workout_params
    params.require(:scheduled_workout_exercises)
  end
end
