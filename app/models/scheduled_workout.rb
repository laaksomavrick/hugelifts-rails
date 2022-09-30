# frozen_string_literal: true

class ScheduledWorkout < ApplicationRecord
  belongs_to :workout_day
  belongs_to :user
  has_many :scheduled_workout_exercises, dependent: :destroy
end
