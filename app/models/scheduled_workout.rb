# frozen_string_literal: true

class ScheduledWorkout < ApplicationRecord
  belongs_to :workout_day
  belongs_to :user
  # TODO: ordinal
  has_many :scheduled_workout_exercises, lambda {
                                           order(created_at: :asc)
                                         }, dependent: :destroy, inverse_of: :scheduled_workout

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
