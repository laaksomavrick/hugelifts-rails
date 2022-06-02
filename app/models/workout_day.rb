# frozen_string_literal: true

class WorkoutDay < ApplicationRecord
  belongs_to :workout
  has_many :workout_day_exercises, dependent: :destroy
end
