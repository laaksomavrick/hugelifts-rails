# frozen_string_literal: true

class CreateWorkoutDays < ActiveRecord::Migration[7.0]
  def change
    create_table :workout_days do |t|
      t.references :workout, null: false
      t.integer :ordinal, null: false, default: 0
      t.string :name, null: false
      t.timestamps
    end
  end
end
