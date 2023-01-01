# frozen_string_literal: true

class WorkoutDayExercise < ApplicationRecord
  include NameParameterizable
  include ResetScheduledWorkout

  belongs_to :workout_day
  belongs_to :exercise

  has_many :exercise_weight_attempts, dependent: :destroy

  after_create :create_exercise_weight_attempt, if: :no_attempt_exists?

  store_accessor :meta, :sets, :reps, :weight, :unit

  validates :sets, numericality: { greater_than: 0, only_integer: true }
  validates :reps, numericality: { greater_than: 0, only_integer: true }
  validates :weight, numericality: { greater_than: 0, only_integer: true }
  validates :unit, inclusion: { in: %w[lb kg] }

  validate :weight, :multiple_of_five?

  delegate :name, to: :exercise
  delegate :workout, to: :workout_day

  def self.policy_class
    WorkoutDayExercisePolicy
  end

  def current_attempt
    attempts = exercise_weight_attempts.order(created_at: :desc)

    return create_exercise_weight_attempt if attempts.empty?

    attempts.first
  end

  def increase_weight!
    # TODO: accommodate kg
    self.weight += 5
    exercise_weight_attempts.new(
      weight: self.weight
    )
    save!
  end

  def decrease_weight!
    # TODO: accommodate kg
    self.weight -= 5
    exercise_weight_attempts.new(
      weight: self.weight
    )
    save!
  end

  private

  def no_attempt_exists?
    exercise_weight_attempts.empty?
  end

  def create_exercise_weight_attempt
    exercise_weight_attempts.create(weight: self.weight)
  end

  def multiple_of_five?
    ok = (weight % 5).zero?
    errors.add(:weight, 'must be multiple of five') unless ok
  end
end
