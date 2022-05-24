# frozen_string_literal: true

class CreateWorkouts < ActiveRecord::Migration[7.0]
  def change
    create_table :workouts do |t|
      t.references :user, null: false
      t.string :name, null: false
      t.boolean :active, null: false
      t.timestamps
    end
  end
end
