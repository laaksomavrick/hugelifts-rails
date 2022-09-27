# frozen_string_literal: true

class AddOrdinalIndexToWorkoutDays < ActiveRecord::Migration[7.0]
  def change
    add_index :workout_days, %i[workout_id ordinal]
  end
end
