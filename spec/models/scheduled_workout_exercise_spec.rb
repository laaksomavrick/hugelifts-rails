# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduledWorkoutExercise do
  it 'can create a scheduled_workout_exercise' do
    scheduled_workout_exercise = create(:scheduled_workout_exercise)
    expect(scheduled_workout_exercise.valid?).to be(true)
  end

  it 'can create an incomplete scheduled_workout_exercise' do
    scheduled_workout_exercise = create(:scheduled_workout_exercise, result: [])
    expect(scheduled_workout_exercise.valid?).to be(true)
  end

  it 'has an error when sets in result are wrong' do
    scheduled_workout_exercise = create(:scheduled_workout_exercise, sets: 4, reps: 10)
    scheduled_workout_exercise.result = [10, 10, 10]
    expect(scheduled_workout_exercise.valid?).to be(false)
    expect(scheduled_workout_exercise.errors.full_messages)
      .to include('Result has wrong number of sets for workout exercise')
  end

  it 'has an error when reps in result are wrong' do
    scheduled_workout_exercise = create(:scheduled_workout_exercise, sets: 4, reps: 10)
    scheduled_workout_exercise.result = [-1, 99, 10, 10]
    expect(scheduled_workout_exercise.valid?).to be(false)
    expect(scheduled_workout_exercise.errors.full_messages).to include('Result has wrong rep amount provided')
  end

  describe 'success?' do
    it 'is successful when each set has the required reps completed' do
      scheduled_workout_exercise = create(:scheduled_workout_exercise, sets: 4, reps: 10)
      scheduled_workout_exercise.result = [10, 10, 10, 10]
      expect(scheduled_workout_exercise.success?).to be(true)
    end

    it 'is not successful when a set is missing required reps' do
      scheduled_workout_exercise = create(:scheduled_workout_exercise, sets: 4, reps: 10)
      scheduled_workout_exercise.result = [10, 10, 10, 5]
      expect(scheduled_workout_exercise.success?).to be(false)
    end
  end

  describe 'failure_threshold_exceedable?' do
    let!(:workout_day_exercise) { create(:workout_day_exercise, :with_exercise_weight_attempt) }
    let!(:workout_day) { workout_day_exercise.workout_day }
    let!(:exercise_weight_attempt) { workout_day_exercise.current_attempt }
    let!(:scheduled_workout) { create(:scheduled_workout, workout_day:, skipped: false, completed: true) }
    let!(:successful_result) { Array(0..workout_day_exercise.sets - 1).map { workout_day_exercise.reps } }

    it 'is not exceedable when no prior workouts exist' do
      scheduled_workout_exercise = create(:scheduled_workout_exercise, sets: 4, reps: 10, result: [10, 10, 8, 7])
      expect(scheduled_workout_exercise.failure_threshold_exceedable?).to be(false)
    end

    it 'is not exceedable when prior workouts happened before weight decreased' do
      # When prior attempts occur at the same weight that were failed and then a change happened, we don't want these to
      # be included in the lookback for this method.
      # In other words, each "attempt" (set of scheduled workout exercises at a specific weight)
      # should be independent of prior "attempts"
      # We introduced ExerciseWeightAttempt to facilitate this grouping

      # Create prior attempts

      ScheduledWorkoutExercise::PRIOR_ATTEMPT_LOOKBACK.times do
        create(:scheduled_workout_exercise, workout_day_exercise:, sets: workout_day_exercise.sets,
                                            reps: workout_day_exercise.reps, result: [])
      end

      create(:scheduled_workout_exercise, workout_day_exercise:,
                                          sets: workout_day_exercise.sets,
                                          reps: workout_day_exercise.reps, result: [])

      # Failed, decrease weight
      workout_day_exercise.decrease_weight!
      workout_day_exercise.save!

      # Success, increase weight
      create(:scheduled_workout_exercise, workout_day_exercise:,
                                          sets: workout_day_exercise.sets,
                                          reps: workout_day_exercise.reps,
                                          result: Array(0..workout_day_exercise.sets - 1)
                                                    .map do
                                                    workout_day_exercise.reps
                                                  end)

      workout_day_exercise.increase_weight!
      workout_day_exercise.save!

      # New attempt, failure_threshold_exceedable? should be false
      scheduled_workout_exercise = create(:scheduled_workout_exercise, workout_day_exercise:,
                                                                       sets: workout_day_exercise.sets,
                                                                       reps: workout_day_exercise.reps, result: [])

      expect(scheduled_workout_exercise.failure_threshold_exceedable?).to be(false)
    end

    it 'is not exceedable when less than lookback prior workouts were not successful' do
      (ScheduledWorkoutExercise::PRIOR_ATTEMPT_LOOKBACK - 1).times do
        create(:scheduled_workout_exercise, workout_day_exercise:, sets: workout_day_exercise.sets,
                                            reps: workout_day_exercise.reps, result: [], exercise_weight_attempt:)
      end

      scheduled_workout_exercise = create(:scheduled_workout_exercise, workout_day_exercise:,
                                                                       sets: workout_day_exercise.sets,
                                                                       reps: workout_day_exercise.reps, result: [])

      expect(scheduled_workout_exercise.failure_threshold_exceedable?).to be(false)
    end

    it 'is not exceedable when prior workouts were successful and a skip is included' do
      ScheduledWorkoutExercise::PRIOR_ATTEMPT_LOOKBACK.times do
        create(:scheduled_workout_exercise, workout_day_exercise:, sets: workout_day_exercise.sets,
                                            reps: workout_day_exercise.reps,
                                            result: successful_result, exercise_weight_attempt:)
      end

      # Create a valid result for a skipped workout
      skipped_scheduled_workout = create(:scheduled_workout, workout_day:, skipped: true, completed: true)
      create(:scheduled_workout_exercise, scheduled_workout: skipped_scheduled_workout, workout_day_exercise:,
                                          weight: 0,
                                          sets: workout_day_exercise.sets,
                                          reps: workout_day_exercise.reps,
                                          result: [])

      scheduled_workout_exercise = create(:scheduled_workout_exercise, workout_day_exercise:,
                                                                       sets: workout_day_exercise.sets,
                                                                       reps: workout_day_exercise.reps, result: [])

      expect(scheduled_workout_exercise.failure_threshold_exceedable?).to be(false)
    end

    it 'is exceedable when prior workouts were not successful' do
      ScheduledWorkoutExercise::PRIOR_ATTEMPT_LOOKBACK.times do
        create(:scheduled_workout_exercise, workout_day_exercise:, scheduled_workout:, sets: workout_day_exercise.sets,
                                            reps: workout_day_exercise.reps, result: [], exercise_weight_attempt:)
      end

      scheduled_workout_exercise = create(:scheduled_workout_exercise, scheduled_workout:, workout_day_exercise:,
                                                                       sets: workout_day_exercise.sets,
                                                                       reps: workout_day_exercise.reps, result: [])

      expect(scheduled_workout_exercise.failure_threshold_exceedable?).to be(true)
    end

    it 'is exceedable when prior workouts were not successful and a skip is included' do
      ScheduledWorkoutExercise::PRIOR_ATTEMPT_LOOKBACK.times do
        create(:scheduled_workout_exercise, workout_day_exercise:, scheduled_workout:, sets: workout_day_exercise.sets,
                                            reps: workout_day_exercise.reps, result: [], exercise_weight_attempt:)
      end

      scheduled_workout_exercise = create(:scheduled_workout_exercise, scheduled_workout:, workout_day_exercise:,
                                                                       sets: workout_day_exercise.sets,
                                                                       reps: workout_day_exercise.reps, result: [])

      # Create a valid result for a skipped workout
      skipped_scheduled_workout = create(:scheduled_workout, workout_day:, skipped: true, completed: true)
      create(:scheduled_workout_exercise, scheduled_workout: skipped_scheduled_workout, workout_day_exercise:,
                                          weight: 0,
                                          sets: workout_day_exercise.sets,
                                          reps: workout_day_exercise.reps,
                                          result: successful_result)

      expect(scheduled_workout_exercise.failure_threshold_exceedable?).to be(true)
    end
  end
end
