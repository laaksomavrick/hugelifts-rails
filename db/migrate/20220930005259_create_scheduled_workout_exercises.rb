# frozen_string_literal: true

class CreateScheduledWorkoutExercises < ActiveRecord::Migration[7.0]
  def change
    create_table :scheduled_workout_exercises do |t|
      t.references :scheduled_workout, null: false
      t.references :workout_day_exercise, null: false
      t.numeric :sets, null: false
      t.numeric :reps, null: false
      t.numeric :weight, null: false
      t.integer :result, array: true, default: []
      t.timestamps
    end
  end
end
