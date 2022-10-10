# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exercise, type: :model do
  it 'can create an exercise' do
    exercise = create(:exercise)
    expect(exercise.valid?).to be(true)
  end

  it 'requires a name' do
    expect do
      create(:exercise, name: '')
    end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end
end
