# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduledWorkout do
  it 'can create a scheduled_workout' do
    scheduled_workout = create(:scheduled_workout)
    expect(scheduled_workout.valid?).to be(true)
  end
end
