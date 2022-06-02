# frozen_string_literal: true

class CreateWorkoutDayExercises < ActiveRecord::Migration[7.0]
  def change
    create_table :workout_day_exercises do |t|
      t.references :workout_day, null: false
      t.references :exercise, null: false
      t.column :meta, :jsonb, default: {}
      t.timestamps
    end
  end
end
