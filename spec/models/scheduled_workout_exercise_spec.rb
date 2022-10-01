# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduledWorkoutExercise, type: :model do
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
    expect(scheduled_workout_exercise.errors.full_messages).to include('Result has wrong number of sets for workout exercise')
  end

  it 'has an error when reps in result are wrong' do
    scheduled_workout_exercise = create(:scheduled_workout_exercise, sets: 4, reps: 10)
    scheduled_workout_exercise.result = [-1, 99, 10, 10]
    expect(scheduled_workout_exercise.valid?).to be(false)
    expect(scheduled_workout_exercise.errors.full_messages).to include('Result has wrong rep amount provided')
  end
end
