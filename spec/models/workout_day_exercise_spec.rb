# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkoutDayExercise, type: :model do
  let!(:workout_day_exercise) { create(:workout_day_exercise) }

  it 'must have a positive number of sets' do
    workout_day_exercise.sets = 0
    expect(workout_day_exercise.valid?).to be(false)
  end

  it 'must have a positive number of reps' do
    workout_day_exercise.reps = 0
    expect(workout_day_exercise.valid?).to be(false)
  end

  it 'must have a positive number for weight' do
    workout_day_exercise.weight = 0
    expect(workout_day_exercise.valid?).to be(false)
  end

  it 'must have a unit of lbs or kgs' do
    workout_day_exercise.unit = 'foo'
    expect(workout_day_exercise.valid?).to be(false)

    workout_day_exercise.unit = 'lb'
    expect(workout_day_exercise.valid?).to be(true)

    workout_day_exercise.unit = 'kg'
    expect(workout_day_exercise.valid?).to be(true)
  end

  # Whenever something changes in our workout_day_exercise for the active workout
  # we want those changes to be propagated to 'todays workout' for the user
  # E.g. they add an exercise for the active workout day or change a weight
  describe 'scheduled workout update' do
    pending 'it deletes the scheduled workout on creation if workout is active'
    pending 'it deletes the scheduled workout on update if workout is active'
    pending 'it deletes the scheduled workout on delete if workout is active'
  end

  describe 'increase_weight!' do
    it 'increases the weight by 5lbs' do
      former_weight = workout_day_exercise.weight
      workout_day_exercise.increase_weight!
      expect(workout_day_exercise.weight).to be(former_weight + 5)
    end
  end
end
