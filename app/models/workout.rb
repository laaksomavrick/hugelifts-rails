# frozen_string_literal: true

class Workout < ApplicationRecord
  include NameParameterizable

  alias_attribute :days, :workout_days

  belongs_to :user
  has_many :workout_days, dependent: :destroy

  validates :name, presence: true
  validates :active, uniqueness: { scope: %i[user_id active] }, if: :active

  def save_with_active!(user_id:)
    transaction do
      Workout.where(user_id:).update(active: false) if active
      save!
    end
  end
end
