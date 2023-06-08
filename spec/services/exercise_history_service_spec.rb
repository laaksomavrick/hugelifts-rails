# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExerciseHistoryService do
  let!(:user) { create(:user) }
  let!(:workout) { create(:workout, user:) }
  let!(:workout_day) { create(:workout_day, :with_exercises, workout:) }
  let!(:workout_day_exercise) { workout_day.exercises.first }
  let!(:exercise) { workout_day_exercise.exercise }
  let!(:scheduled_workouts) { create_list(:scheduled_workout, 3, workout_day:, completed: true, user:) }

  before do
    first = scheduled_workouts.first
    second = scheduled_workouts.second
    third = scheduled_workouts.third

    # rubocop:disable Lint/UselessTimes
    first.scheduled_workout_exercises =
      1.times.map do
        create(:scheduled_workout_exercise,
               scheduled_workout: first,
               workout_day_exercise:, sets: 4, reps: 10, result: [7, 5, 4, 2],
               created_at: 3.days.ago)
      end
    second.scheduled_workout_exercises = 1.times.map do
      create(:scheduled_workout_exercise,
             scheduled_workout: second,
             workout_day_exercise:,
             sets: 4, reps: 10, result: [8, 7, 6, 6],
             created_at: 2.days.ago)
    end
    third.scheduled_workout_exercises = 1.times.map do
      create(:scheduled_workout_exercise,
             scheduled_workout: third,
             workout_day_exercise:,
             sets: 4, reps: 10, result: [10, 9, 8, 7],
             created_at: 1.day.ago)
    end
    # rubocop:enable Lint/UselessTimes
  end

  it 'retrieves the workout history of an exercise' do
    history = described_class.new(user:, exercise:).call

    expect(history.length).to be scheduled_workouts.length

    expect(history.first.one_rep_max).to be > workout_day_exercise.weight

    expect(history.first.name).to eq history.second.name
    expect(history.second.name).to eq history.third.name

    expect(history.first.one_rep_max).to be < history.second.one_rep_max
    expect(history.second.one_rep_max).to be < history.third.one_rep_max
  end

  it 'retrieves the most recent workout histories for an exercise' do
    exercises = ScheduledWorkoutExercise.order(created_at: :asc).all
    history = described_class.new(user:, exercise:).call(2)

    expect(history.first.id).to eq exercises.second.id
    expect(history.second.id).to eq exercises.third.id
  end

  it 'does not include skipped exercises' do
    skipped_scheduled_workout = create(:scheduled_workout, workout_day:, completed: true, skipped: true, user:)
    skipped = create(:scheduled_workout_exercise,
                     scheduled_workout: skipped_scheduled_workout,
                     workout_day_exercise:, sets: 4, reps: 10, result: [0, 0, 0, 0],
                     created_at: 0.days.ago)

    history = described_class.new(user:, exercise:).call

    expect(history.length).to be scheduled_workouts.length
    expect(history.map(&:id)).not_to include(skipped.id)
  end
end
