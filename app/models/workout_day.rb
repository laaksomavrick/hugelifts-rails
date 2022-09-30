# frozen_string_literal: true

class WorkoutDay < ApplicationRecord
  include NameParameterizable

  belongs_to :workout
  has_many :workout_day_exercises, dependent: :destroy
  has_many :scheduled_workouts, dependent: :nullify

  validates :name, presence: true

  def self.policy_class
    WorkoutDayPolicy
  end

  # TODO: can extract this to a common module when needs to be generalized
  def self.swap_ordinal!(obj, new_ordinal)
    transaction do
      collection = where.not(id: obj.id).order(ordinal: :asc).to_a
      collection.insert(new_ordinal, obj)
      # TODO: make this more efficient
      collection.each_with_index do |wd, i|
        wd.ordinal = i
        wd.save!
      end
    end
  end
end
