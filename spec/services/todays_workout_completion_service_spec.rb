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
    # Set one exercise to have been successful
    successful_exercise_id = workout_results.keys.first
    successful_exercise = todays_workout.exercises.find_by(id: successful_exercise_id.to_i)
    successful_exercise_old_weight = successful_exercise.weight
    workout_results[successful_exercise_id]['result'] = successful_exercise.sets.times.map { successful_exercise.reps }

    service = described_class.new(todays_workout:, workout_results:)
    ok = service.call

    expect(ok).to be(true)
    # Completed is set to true
    expect(ScheduledWorkout.find_by(id: todays_workout.id).completed).to be(true)
    # Weight is increased for one
    expect(successful_exercise.workout_day_exercise.weight).to be > successful_exercise_old_weight
  end
end
