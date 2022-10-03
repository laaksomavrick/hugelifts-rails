# frozen_string_literal: true

# TODO: on completion of an exercise, increase the weight

class TodaysWorkoutController < ApplicationController
  def index
    policy_scope(ScheduledWorkout)
    scheduled_workout = TodaysWorkoutService.new(user: current_user).call
    @todays_workout = TodaysWorkoutPresenter.new(scheduled_workout:)
  end
end
