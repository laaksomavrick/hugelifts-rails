# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Workout, type: :model do
  it 'can create a workout' do
    workout = create(:workout)
    expect(workout.valid?).to be(true)
  end

  it 'requires a name' do
    expect do
      create(:workout, name: '')
    end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end

  it 'can only have one active workout per user' do
    user = create(:user)
    create(:workout, user:, active: true)
    expect do
      create(:workout, user:, active: true)
    end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Active has already been taken')
  end

  it 'sets other workouts to inactive when active' do
    user = create(:user)
    inactive_workouts = create_list(:workout, 3, user:)
    inactive_workout = inactive_workouts.first
    create(:workout, user:, active: true)

    inactive_workout.active = true
    inactive_workout.save_with_active!(user_id: user.id)

    expect(inactive_workout.active).to be_truthy
    expect(described_class.where.not(id: inactive_workout.id).all.map(&:active)).to all(be_falsey)
  end
end
