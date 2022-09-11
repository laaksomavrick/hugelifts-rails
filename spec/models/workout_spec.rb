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
end
