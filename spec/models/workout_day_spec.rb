# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkoutDay, type: :model do
  describe 'reordering' do
    let!(:workout) { create(:workout, :with_days) }

    let!(:first) { workout.workout_days.first }
    let!(:last) { workout.workout_days.last }

    let!(:collection) { described_class.where(workout:).order(ordinal: :asc) }

    it "can reorder a workout day to be first in it's workout" do
      described_class.swap_ordinal!(last, 0)

      expect(collection.first.id).to eq last.id
    end

    it "can reorder a workout day to be last in it's workout" do
      described_class.swap_ordinal!(first, 2)

      expect(collection.last.id).to eq first.id
    end

    it "can reorder a workout day to be in the middle of it's workout" do
      described_class.swap_ordinal!(first, 1)

      expect(collection[1].id).to eq first.id
    end
  end

  # Whenever something changes in our workout_day for the active workout
  # we want those changes to be propagated to 'todays workout' for the user
  # E.g. they rename the workout day or modify the days in the workout
  describe 'reset scheduled workout' do
    let!(:user) { create(:user) }
    let!(:active_workout) { user.active_workout }
    let!(:inactive_workout) { user.workouts.where(active: false).first }
    let!(:active_workout_day) { active_workout.workout_days.first }
    let!(:inactive_workout_day) { inactive_workout.workout_days.first }

    before do
      create(:scheduled_workout, user:, workout_day: active_workout_day)
    end

    it 'does not delete the scheduled workout on creation' do
      new_workout_day = described_class.create(workout: active_workout, name: 'foo',
                                               ordinal: active_workout.workout_days.count)
      new_workout_day.save!

      scheduled_workout = ScheduledWorkout.where(workout_day: active_workout_day).where(completed: false).first

      expect(scheduled_workout).not_to be_nil
    end

    it 'does not delete the scheduled workout on update if workout is not active' do
      inactive_workout_day.name = 'foo'
      inactive_workout_day.save!

      scheduled_workout = ScheduledWorkout.where(workout_day: active_workout_day).where(completed: false).first

      expect(scheduled_workout).not_to be_nil
    end

    it 'does not delete the scheduled workout on delete if workout is not active' do
      inactive_workout_day.destroy!

      scheduled_workout = ScheduledWorkout.where(workout_day: active_workout_day).where(completed: false).first

      expect(scheduled_workout).not_to be_nil
    end

    it 'deletes the scheduled workout on update if workout is active' do
      active_workout_day.name = 'foo'
      active_workout_day.save!

      scheduled_workout = ScheduledWorkout.where(workout_day: active_workout_day).where(completed: false).first

      expect(scheduled_workout).to be_nil
    end

    it 'deletes the scheduled workout on delete if workout is active' do
      active_workout_day.destroy!

      scheduled_workout = ScheduledWorkout.where(workout_day: active_workout_day).where(completed: false).first

      expect(scheduled_workout).to be_nil
    end
  end
end
