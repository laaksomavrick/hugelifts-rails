# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduledWorkout, type: :model do
  it 'can create a scheduled_workout' do
    scheduled_workout_exercise = create(:scheduled_workout)
    expect(scheduled_workout_exercise.valid?).to be(true)
  end
end
