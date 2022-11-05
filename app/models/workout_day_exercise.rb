# frozen_string_literal: true

class WorkoutDayExercise < ApplicationRecord
  include NameParameterizable
  include ResetScheduledWorkout

  belongs_to :workout_day
  belongs_to :exercise
  store_accessor :meta, :sets, :reps, :weight, :unit

  validates :sets, numericality: { greater_than: 0, only_integer: true }
  validates :reps, numericality: { greater_than: 0, only_integer: true }
  # TODO: validate mod 5 == 0
  validates :weight, numericality: { greater_than: 0, only_integer: true }
  validates :unit, inclusion: { in: %w[lb kg] }

  delegate :name, to: :exercise
  delegate :workout, to: :workout_day

  def self.policy_class
    WorkoutDayExercisePolicy
  end

  def increase_weight!
    # TODO: accommodate kg
    self.weight += 5
  end
end
