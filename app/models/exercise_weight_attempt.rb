# frozen_string_literal: true

class ExerciseWeightAttempt < ApplicationRecord
  belongs_to :workout_day_exercise
  has_many :scheduled_workout_exercises, dependent: :nullify
end
