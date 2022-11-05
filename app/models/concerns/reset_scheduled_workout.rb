# frozen_string_literal: true

module ResetScheduledWorkout
  extend ActiveSupport::Concern

  included do
    after_commit :reset_scheduled_workout_if_active, on: %i[create update destroy]
  end

  def reset_scheduled_workout_if_active
    return if workout.active? == false

    scheduled_workout = ScheduledWorkout.where(workout_day:).where(completed: false).first

    return if scheduled_workout.nil?

    scheduled_workout.destroy
  end

  # TODO: would be nice to write "workout" and "workout_day" methods
  # here to make it explicit they need to be in mixed-in classes
end
