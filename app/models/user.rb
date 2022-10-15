# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :exercises, dependent: :destroy
  has_many :workouts, dependent: :destroy
  has_many :scheduled_workouts, dependent: :destroy

  after_save :set_default_exercises
  after_save :set_default_workouts

  private

  def set_default_exercises
    self.exercises = Exercise.default_exercises
  end

  def set_default_workouts
    self.workouts = DefaultWorkoutsService.new(user: self).call
  end
end
