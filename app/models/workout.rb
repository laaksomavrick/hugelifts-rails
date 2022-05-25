# frozen_string_literal: true

class Workout < ApplicationRecord
  alias_attribute :days, :workout_days

  belongs_to :user
  has_many :workout_days, dependent: :destroy
end
