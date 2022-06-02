# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkoutDayExercise, type: :model do
  let!(:daily_workout_exercise) { create(:daily_workout_exercise) }

  it 'must have a positive number of sets' do
    daily_workout_exercise.sets = 0
    expect(daily_workout_exercise.valid?).to be(false)
  end

  it 'must have a positive number of reps' do
    daily_workout_exercise.reps = 0
    expect(daily_workout_exercise.valid?).to be(false)
  end

  it 'must have a positive number for weight' do
    daily_workout_exercise.weight = 0
    expect(daily_workout_exercise.valid?).to be(false)
  end

  it 'must have a unit of lbs or kgs' do
    daily_workout_exercise.unit = 'foo'
    expect(daily_workout_exercise.valid?).to be(false)

    daily_workout_exercise.unit = 'lb'
    expect(daily_workout_exercise.valid?).to be(true)

    daily_workout_exercise.unit = 'kg'
    expect(daily_workout_exercise.valid?).to be(true)
  end
end
