class AddSkippedToScheduledWorkout < ActiveRecord::Migration[7.0]
  def change
    add_column :scheduled_workouts, :skipped, :boolean, default: false, null: false
  end
end