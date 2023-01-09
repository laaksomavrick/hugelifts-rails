# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable

  has_many :exercises, dependent: :destroy
  has_many :workouts, dependent: :destroy
  has_many :scheduled_workouts, dependent: :destroy

  after_save :set_default_exercises
  after_save :set_default_workouts

  def active_workout
    workouts.where(active: true).first
  end

  private

  def set_default_exercises
    self.exercises = Exercise.default_exercises
  end

  def set_default_workouts
    self.workouts = DefaultWorkoutsService.new(user: self).call
  end
end
