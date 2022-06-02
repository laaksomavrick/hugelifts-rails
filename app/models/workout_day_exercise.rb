# frozen_string_literal: true

class WorkoutDayExercise < ApplicationRecord
  belongs_to :workout_day
  belongs_to :exercise
  store_accessor :meta, :sets, :reps, :weight, :unit

  validates :sets, numericality: { greater_than: 0 }
  validates :reps, numericality: { greater_than: 0 }
  validates :weight, numericality: { greater_than: 0 }
  validates :unit, inclusion: { in: %w[lb kg] }
end
