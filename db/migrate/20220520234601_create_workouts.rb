# frozen_string_literal: true

class CreateWorkouts < ActiveRecord::Migration[7.0]
  def change
    create_table :workouts do |t|
      t.references :user, null: false
      t.string :name, null: false
      # rubocop:disable Rails/ThreeStateBooleanColumn
      t.boolean :active, null: false
      # rubocop:enable Rails/ThreeStateBooleanColumn
      t.timestamps
    end
  end
end
