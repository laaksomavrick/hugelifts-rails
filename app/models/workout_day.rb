# frozen_string_literal: true

class WorkoutDay < ApplicationRecord
  belongs_to :workout
  has_many :daily_workout_exercises, dependent: :destroy
end
