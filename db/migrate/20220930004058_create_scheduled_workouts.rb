# frozen_string_literal: true

class CreateScheduledWorkouts < ActiveRecord::Migration[7.0]
  def change
    create_table :scheduled_workouts do |t|
      t.references :workout_day
      t.references :user, null: false
      t.boolean :completed, default: false, null: false
      t.timestamps
    end
  end
end
