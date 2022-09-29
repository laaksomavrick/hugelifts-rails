# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkoutDay, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

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
end
