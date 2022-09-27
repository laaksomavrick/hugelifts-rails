# frozen_string_literal: true

class AddOrdinalIndexToWorkoutDays < ActiveRecord::Migration[7.0]
  def change
    # remove_index :workout_days, %i[workout_id ordinal]
    add_index :workout_days, %i[workout_id ordinal], unique: true
  end
end
