# frozen_string_literal: true

class WorkoutDay < ApplicationRecord
  include NameParameterizable

  belongs_to :workout
  has_many :workout_day_exercises, dependent: :destroy

  validates :name, presence: true
end
