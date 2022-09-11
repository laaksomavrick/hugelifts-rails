# frozen_string_literal: true

class AddActiveIndexToWorkout < ActiveRecord::Migration[7.0]
  def change
    add_index :workouts, %i[user_id active]
  end
end
