# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'creates exercises on creation' do
    user = create(:user)
    expect(user.exercises.length).to eq Exercise.default_exercises.length
  end
end
