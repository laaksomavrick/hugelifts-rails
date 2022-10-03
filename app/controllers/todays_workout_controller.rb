# frozen_string_literal: true

# TODO: on completion of an exercise, increase the weight

class TodaysWorkoutController < ApplicationController
  def index
    # TODO: policy_scope(nil, policy_scope_class: TodaysWorkoutPolicy::Scope)
    # TODO: todays_workout_presenter
    @todays_workout = TodaysWorkoutService.new(user: current_user).call
  end
end
