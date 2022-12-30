# frozen_string_literal: true

class CreateExerciseWeightAttempts < ActiveRecord::Migration[7.0]
  def change
    create_table :exercise_weight_attempts do |t|
      t.references :workout_day_exercise, null: false
      t.integer :weight, null: false
      t.timestamps
    end

    add_reference :scheduled_workout_exercises, :exercise_weight_attempt, foreign_key: true
  end
end
