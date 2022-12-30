# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodaysWorkoutCompletionService do
  let!(:todays_workout) { create(:scheduled_workout, :with_exercises) }
  let!(:workout_results) do
    results = {}
    todays_workout.scheduled_workout_exercises.each do |e|
      result = e.sets.times.map { 0 }
      results[e.id.to_s] = { 'result' => result }
    end
    results
  end

  it 'can complete a workout' do
    exercise_id = workout_results.keys.first
    successful_exercise = todays_workout.exercises.find_by(id: exercise_id.to_i)
    successful_exercise_old_weight = successful_exercise.weight
    workout_results[exercise_id]['result'] = successful_exercise.sets.times.map { 0 }

    service = described_class.new(todays_workout:, workout_results:)
    ok = service.call

    expect(ok).to be(true)
    # Completed is set to true
    expect(ScheduledWorkout.find_by(id: todays_workout.id).completed).to be(true)
    # Weight stayed the same
    expect(successful_exercise.workout_day_exercise.weight).to be successful_exercise_old_weight
  end

  it 'increments weight when all reps for sets performed' do
    successful_exercise_id = workout_results.keys.first
    successful_exercise = todays_workout.exercises.find_by(id: successful_exercise_id.to_i)
    successful_exercise_old_weight = successful_exercise.weight
    workout_results[successful_exercise_id]['result'] = successful_exercise.sets.times.map { successful_exercise.reps }

    service = described_class.new(todays_workout:, workout_results:)
    service.call

    # Weight is increased by 5
    expect(successful_exercise.workout_day_exercise.weight).to be successful_exercise_old_weight + 5
  end

  it 'decrements weight when all reps for sets not performed 3 times in a row' do
    user = todays_workout.user
    workout_day = todays_workout.workout_day
    workout_day_exercise = workout_day.exercises.first
    exercise_weight_attempt = create(:exercise_weight_attempt, workout_day_exercise:)

    failed_exercise_id = workout_results.keys.first
    failed_exercise = todays_workout.exercises.find_by(id: failed_exercise_id.to_i)
    failed_exercise_old_weight = failed_exercise.weight

    # Set one success and then two failures
    failed_result = failed_exercise.sets.times.map { 0 }
    successful_result = failed_exercise.sets.times.map { failed_exercise.reps }

    scheduled_workout_first = create(:scheduled_workout, workout_day:, user:)
    create(:scheduled_workout_exercise, scheduled_workout: scheduled_workout_first, workout_day_exercise:,
                                        result: successful_result, exercise_weight_attempt:)

    scheduled_workout_second = create(:scheduled_workout, workout_day:, user:)
    create(:scheduled_workout_exercise, scheduled_workout: scheduled_workout_second, workout_day_exercise:,
                                        result: failed_result, exercise_weight_attempt:)

    scheduled_workout_third = create(:scheduled_workout, workout_day:, user:)
    create(:scheduled_workout_exercise, scheduled_workout: scheduled_workout_third, workout_day_exercise:,
                                        result: failed_result, exercise_weight_attempt:)

    # Fail this time too
    workout_results[failed_exercise_id]['result'] = failed_exercise.sets.times.map { 0 }

    service = described_class.new(todays_workout:, workout_results:)
    service.call

    # Weight is decreased by 5
    expect(failed_exercise.workout_day_exercise.weight).to be failed_exercise_old_weight - 5
  end
end
