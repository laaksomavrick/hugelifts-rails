# frozen_string_literal: true

class ScheduledWorkoutExercise < ApplicationRecord
  belongs_to :scheduled_workout
  belongs_to :workout_day_exercise

  validates :sets, presence: true
  validates :reps, presence: true

  validate :result_length

  def empty_result
    sets.times.map { 0 }
  end

  def success?
    result.all? { |x| x == reps }
  end

  def failure_threshold_exceeded?
    prior_attempts = ScheduledWorkoutExercise
                     .where(workout_day_exercise:)
                     .where.not(id:)
                     .order(created_at: :desc)
                     .limit(2)
    !prior_attempts.all?(&:success?)
  end

  private

  def result_length
    return if result == []

    correct_sets = result.length == sets
    correct_reps = result.all? { |x| x >= 0 && x <= reps }

    errors.add(:result, 'has wrong number of sets for workout exercise') unless correct_sets
    errors.add(:result, 'has wrong rep amount provided') unless correct_reps
  end
end
