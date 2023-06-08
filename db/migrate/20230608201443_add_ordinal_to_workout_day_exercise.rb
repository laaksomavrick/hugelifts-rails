# frozen_string_literal: true

class AddOrdinalToWorkoutDayExercise < ActiveRecord::Migration[7.0]
  def change
    add_column :workout_day_exercises, :ordinal, :integer, null: false, default: 0
    WorkoutDay.all.each do |workout_day|
      workout_day.workout_day_exercises.order(:created_at).each.with_index(0) do |wde, i|
        wde.update_column :ordinal, i
      end
    end
  end
end
