# frozen_string_literal: true

class ScheduledWorkoutExercise < ApplicationRecord
  belongs_to :scheduled_workout
  belongs_to :workout_day_exercise

  validates :sets, presence: true
  validates :reps, presence: true

  validate :result_length

  private

  def result_length
    correct_sets = result.length == sets
    correct_reps = result.all? { |x| x >= 0 && x <= reps }

    errors.add(:result, 'has wrong number of sets for workout exercise') unless correct_sets
    errors.add(:result, 'has wrong rep amount provided') unless correct_reps
  end
end