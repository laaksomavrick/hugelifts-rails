# frozen_string_literal: true

class Workout < ApplicationRecord
  alias_attribute :days, :workout_days

  belongs_to :user
  has_many :workout_days, dependent: :destroy

  validates :name, presence: true
  validates :active, uniqueness: { scope: %i[user_id active] }, if: :active
end
