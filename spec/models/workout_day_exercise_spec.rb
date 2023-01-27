# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkoutDayExercise, type: :model do
  let!(:workout_day_exercise) { create(:workout_day_exercise, :with_exercise_weight_attempt) }

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
    expect(workout_day_exercise.valid?).to be(true)
  end

  it 'must have a multiple of five for weight' do
    workout_day_exercise.weight = 1337
    expect(workout_day_exercise.valid?).to be(false)
    expect(workout_day_exercise.errors.full_messages).to include('Weight must be multiple of five')
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
  describe 'scheduled workout reset' do
    let!(:user) { create(:user) }
    let!(:exercise) { create(:exercise) }
    let!(:active_workout_day) { user.active_workout.workout_days.first }
    let!(:inactive_workout_day) { user.workouts.where(active: false).first.workout_days.first }

    before do
      create(:scheduled_workout, user:, workout_day: active_workout_day)
    end

    it 'resets the scheduled workout on wde creation if wde is active' do
      new_workout_day_exercise = described_class.create(workout_day: active_workout_day, exercise:, sets: 4,
                                                        reps: 10, weight: 135, unit: 'lb')
      new_workout_day_exercise.save!

      scheduled_workout = ScheduledWorkout.where(workout_day: active_workout_day).where(completed: false).first

      expect(scheduled_workout).to be_nil
    end

    it 'resets the scheduled workout on wde update if wde is active' do
      wde = active_workout_day.exercises.first
      wde.reps = 12
      wde.save!

      scheduled_workout = ScheduledWorkout.where(workout_day: active_workout_day).where(completed: false).first

      expect(scheduled_workout).to be_nil
    end

    it 'resets the scheduled workout on wde delete if wde is active' do
      wde = active_workout_day.exercises.first
      wde.destroy!

      scheduled_workout = ScheduledWorkout.where(workout_day: active_workout_day).where(completed: false).first

      expect(scheduled_workout).to be_nil
    end

    it 'does not reset the scheduled workout on wde creation if wde is not active' do
      new_workout_day_exercise = described_class.create(workout_day: inactive_workout_day, exercise:, sets: 4,
                                                        reps: 10, weight: 135, unit: 'lb')
      new_workout_day_exercise.save!

      scheduled_workout = ScheduledWorkout.where(workout_day: active_workout_day).where(completed: false).first

      expect(scheduled_workout).not_to be_nil
    end

    it 'does not reset the scheduled workout on wde update if wde is not active' do
      wde = inactive_workout_day.exercises.first
      wde.reps = 12
      wde.save!

      scheduled_workout = ScheduledWorkout.where(workout_day: active_workout_day).where(completed: false).first

      expect(scheduled_workout).not_to be_nil
    end

    it 'does not reset the scheduled workout on wde delete if wde is not active' do
      wde = inactive_workout_day.exercises.first
      wde.destroy!

      scheduled_workout = ScheduledWorkout.where(workout_day: active_workout_day).where(completed: false).first

      expect(scheduled_workout).not_to be_nil
    end
  end

  describe 'increase_weight!' do
    it 'increases the weight by 5lbs' do
      former_weight = workout_day_exercise.weight
      workout_day_exercise.increase_weight!
      expect(workout_day_exercise.weight).to be(former_weight + 5)
    end

    it 'creates a new exercise_weight_attempt' do
      former_attempt = workout_day_exercise.current_attempt

      workout_day_exercise.increase_weight!
      new_attempt = workout_day_exercise.current_attempt

      expect(former_attempt.id).not_to be(new_attempt.id)
      expect(former_attempt.weight).not_to be(new_attempt.weight)
    end
  end

  describe 'decrease_weight!' do
    it 'decreases the weight by 5lbs' do
      former_weight = workout_day_exercise.weight
      workout_day_exercise.decrease_weight!
      expect(workout_day_exercise.weight).to be(former_weight - 5)
    end

    it 'creates a new exercise_weight_attempt' do
      former_attempt = workout_day_exercise.current_attempt

      workout_day_exercise.increase_weight!
      new_attempt = workout_day_exercise.current_attempt

      expect(former_attempt.id).not_to be(new_attempt.id)
      expect(former_attempt.weight).not_to be(new_attempt.weight)
    end
  end

  describe 'current_attempt' do
    let!(:workout_day_exercise) { create(:workout_day_exercise) }

    it 'retrieves the most recent exercise_weight_attempt' do
      create(:exercise_weight_attempt, workout_day_exercise:)
      create(:exercise_weight_attempt, workout_day_exercise:)
      third_attempt = create(:exercise_weight_attempt, workout_day_exercise:)

      current_attempt = workout_day_exercise.current_attempt

      expect(current_attempt.id).to be(third_attempt.id)
    end

    it 'creates a exercise_weight_attempt on creation' do
      current_attempt = workout_day_exercise.current_attempt

      expect(current_attempt).not_to be_nil
    end

    it 'creates a exercise_weight_attempt if none exists' do
      # Need this test case and functionality for existing workout_days prior to the
      # introduction of this model and concept
      ExerciseWeightAttempt.where(workout_day_exercise:).destroy_all
      current_attempt = workout_day_exercise.current_attempt

      expect(current_attempt).not_to be_nil
    end
  end
end
