# frozen_string_literal: true

class Exercise < ApplicationRecord
  include NameParameterizable

  PAGINATION_SIZE = 10
  paginates_per PAGINATION_SIZE

  belongs_to :user
  has_many :workout_day_exercises, dependent: :destroy

  validates :name, presence: true

  BARBELL_BENCH_PRESS = 'Barbell Bench Press'
  INCLINE_BARBELL_BENCH_PRESS = 'Incline Barbell Bench Press'
  DUMBBELL_BENCH_PRESS = 'Dumbbell Bench Press'
  INCLINE_DUMBBELL_BENCH_PRESS = 'Incline Dumbbell Bench Press'
  BARBELL_OVERHEAD_PRESS = 'Barbell Overhead Press'
  SEATED_BARBELL_OVERHEAD_PRESS = 'Seated Barbell Overhead Press'
  DUMBBELL_OVERHEAD_PRESS = 'Dumbbell Overhead Press'
  SEATED_DUMBBELL_OVERHEAD_PRESS = 'Seated Dumbbell Overhead Press'
  BARBELL_SHOULDER_PRESS = 'Barbell Shoulder Press'
  DUMBBELL_SHOULDER_PRESS = 'Dumbbell Shoulder Press'
  DEADLIFT = 'Deadlift'
  ROMANIAN_DEADLIFT = 'Romanian Deadlift'
  BARBELL_ROW = 'Barbell Row'
  PENDLAY_ROW = 'Pendlay Row'
  DUMBBELL_ROW = 'Dumbbell Row'
  BACK_SQUAT = 'Back Squat'
  FRONT_SQUAT = 'Front Squat'
  DUMBBELL_BICEP_CURL = 'Dumbbell Bicep Curl'
  BARBELL_BICEP_CURL = 'Barbell Bicep Curl'
  EZ_BAR_BICEP_CURL = 'EZ-Bar Bicep Curl'
  CHINUP = 'Chinup'
  PULLUP = 'Pullup'
  SKULLCRUSHER = 'Skullcrusher'
  LATERAL_RAISE = 'Lateral Raise'
  BARBELL_SHRUG = 'Barbell Shrug'
  HIP_THRUST = 'Hip Thrust'

  DEFAULT_EXERCISE_NAMES = [
    BARBELL_BENCH_PRESS,
    INCLINE_BARBELL_BENCH_PRESS,
    DUMBBELL_BENCH_PRESS,
    INCLINE_DUMBBELL_BENCH_PRESS,
    BARBELL_OVERHEAD_PRESS,
    DUMBBELL_OVERHEAD_PRESS,
    SEATED_BARBELL_OVERHEAD_PRESS,
    SEATED_DUMBBELL_OVERHEAD_PRESS,
    BARBELL_SHOULDER_PRESS,
    DUMBBELL_SHOULDER_PRESS,
    DEADLIFT,
    ROMANIAN_DEADLIFT,
    BARBELL_ROW,
    PENDLAY_ROW,
    DUMBBELL_ROW,
    BACK_SQUAT,
    FRONT_SQUAT,
    DUMBBELL_BICEP_CURL,
    BARBELL_BICEP_CURL,
    EZ_BAR_BICEP_CURL,
    CHINUP,
    PULLUP,
    SKULLCRUSHER,
    LATERAL_RAISE,
    BARBELL_SHRUG,
    HIP_THRUST
  ].freeze

  class << self
    def default_exercises
      DEFAULT_EXERCISE_NAMES.map { |name| new(name:) }
    end

    def default_exercise_names
      DEFAULT_EXERCISE_NAMES
    end

    def policy_class
      ExercisePolicy
    end
  end
end
