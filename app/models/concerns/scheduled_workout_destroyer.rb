# frozen_string_literal: true

module ScheduledWorkoutDestroyer
  extend ActiveSupport::Concern
  # include ActiveSupport::Callbacks

  after_create :reset_scheduled_workout, if: workout.active?
  after_update :reset_scheduled_workout, if: workout.active?
  after_destroy :reset_scheduled_workout, if: workout.active?

  def reset_scheduled_workout
    scheduled_workout = ScheduledWorkout.where(workout:).where(completed: false).first

    return if scheduled_workout.nil?

    scheduled_workout.destroy!
  end
end
