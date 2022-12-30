# frozen_string_literal: true

class ScheduledWorkoutExercise < ApplicationRecord
  PRIOR_ATTEMPT_LOOKBACK = 2

  belongs_to :scheduled_workout
  belongs_to :workout_day_exercise
  belongs_to :exercise_weight_attempt

  validates :sets, presence: true
  validates :reps, presence: true

  validate :result_length

  def empty_result
    sets.times.map { 0 }
  end

  def success?
    return false if result.empty?

    result.all? { |x| x == reps }
  end

  def failure_threshold_exceeded?
    success? == false && failure_threshold_exceedable?
  end

  def failure_threshold_exceedable?
    prior_attempts_at_current_weight = prior_attempts_at_current_weight(PRIOR_ATTEMPT_LOOKBACK)

    return false if prior_attempts_at_current_weight.count < PRIOR_ATTEMPT_LOOKBACK

    !prior_attempts_at_current_weight.all?(&:success?)
  end

  private

  def prior_attempts_at_current_weight(limit)
    current_attempt = workout_day_exercise.current_attempt

    ScheduledWorkoutExercise
      .where(exercise_weight_attempt: current_attempt)
      .where.not(id:)
      .order(created_at: :desc)
      .limit(limit)
  end

  def result_length
    return if result == []

    correct_sets = result.length == sets
    correct_reps = result.all? { |x| x >= 0 && x <= reps }

    errors.add(:result, 'has wrong number of sets for workout exercise') unless correct_sets
    errors.add(:result, 'has wrong rep amount provided') unless correct_reps
  end
end
