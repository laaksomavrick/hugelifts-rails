# frozen_string_literal: true

class ScheduledWorkoutExercise < ApplicationRecord
  PRIOR_ATTEMPT_LOOKBACK = 2

  belongs_to :scheduled_workout
  belongs_to :workout_day_exercise

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
    # TODO: Need to not return prior attempts at this weight upon decrease - see db - we're returning prior failures instead of new failures. Should return [].
    # attempt_id
    #
    # ExerciseWeightAttempt
    # Create attempt id field as a uuid
    # Use the same attempt for subsequent scheduled_workout_exercises UNLESS
    #   weight increased
    #   weight decreased

    current_weight = workout_day_exercise.weight

    ScheduledWorkoutExercise
      .where(workout_day_exercise:)
      .where.not(id:)
      .where(weight: current_weight)
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
