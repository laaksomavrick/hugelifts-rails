# frozen_string_literal: true

class WorkoutDaysController < ApplicationController
  def show
    workout_day_id = params[:id]
    @workout_day = WorkoutDay.includes(workout_day_exercises: :exercise).find_by(id: workout_day_id)
  end
end
