# frozen_string_literal: true

class ScheduledWorkout < ApplicationRecord
  belongs_to :workout_day
  belongs_to :user
  has_many :scheduled_workout_exercises, dependent: :destroy

  scope :with_exercises, lambda {
                           includes({
                                      workout_day: {
                                        workout_day_exercises: :exercise
                                      }
                                    })
                             .includes(:scheduled_workout_exercises)
                         }

  alias_attribute :exercises, :scheduled_workout_exercises
end
