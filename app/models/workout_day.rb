# frozen_string_literal: true

class WorkoutDay < ApplicationRecord
  include NameParameterizable
  # include ScheduledWorkoutDestroyer

  belongs_to :workout

  # TODO: ordinal
  has_many :workout_day_exercises, -> { order(created_at: :asc) }, dependent: :destroy, inverse_of: :workout_day
  has_many :scheduled_workouts, dependent: :nullify

  alias_attribute :exercises, :workout_day_exercises

  validates :name, presence: true

  after_create :reset_scheduled_workout_if_active
  after_update :reset_scheduled_workout_if_active
  after_destroy :reset_scheduled_workout_if_active

  def reset_scheduled_workout_if_active
    return if workout.active? == false

    scheduled_workout = ScheduledWorkout.where(workout_day: self).where(completed: false).first

    return if scheduled_workout.nil?

    scheduled_workout.destroy
  end

  def self.policy_class
    WorkoutDayPolicy
  end

  # TODO: can extract this to a common module when needs to be generalized
  def self.swap_ordinal!(obj, new_ordinal)
    transaction do
      collection = where(workout_id: obj.workout_id).where.not(id: obj.id).order(ordinal: :asc).to_a
      collection.insert(new_ordinal, obj)
      # TODO: make this more efficient
      collection.each_with_index do |wd, i|
        wd.ordinal = i
        wd.save!
      end
    end
  end
end
