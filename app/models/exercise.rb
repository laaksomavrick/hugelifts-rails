# frozen_string_literal: true

class Exercise < ApplicationRecord
  include NameParameterizable

  belongs_to :user
  has_many :workout_day_exercises, dependent: :destroy

  DEFAULT_EXERCISE_NAMES = [
    'Barbell Bench Press',
    'Incline Barbell Bench Press',
    'Dumbbell Bench Press',
    'Incline Dumbbell Bench Press',
    'Barbell Overhead Press',
    'Dumbbell Overhead Press',
    'Barbell Shoulder Press',
    'Dumbbell Shoulder Press',
    'Deadlift',
    'Romanian Deadlift',
    'Barbell Row',
    'Dumbbell Row',
    'Back Squat',
    'Front Squat',
    'Dumbbell Bicep Curl',
    'Barbell Bicep Curl',
    'EZ-Bar Bicep Curl',
    'Chin up',
    'Pull up',
    'Skullcrusher',
    'Lateral Raise',
    'Barbell Shrug',
    'Situp',
    'Twisting Situp'
  ].freeze

  def self.default_exercises
    DEFAULT_EXERCISE_NAMES.map { |name| new(name:) }
  end

  def self.default_exercise_names
    DEFAULT_EXERCISE_NAMES
  end

  def self.policy_class
    ExercisePolicy
  end
end
