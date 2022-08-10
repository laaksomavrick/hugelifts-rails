# frozen_string_literal: true

class WorkoutsController < ApplicationController
  def index
    @workouts = current_user.workouts
  end

  def edit
    workout_id = params[:id]
    @workout = Workout.includes(:workout_days).find_by(id: workout_id)
  end
end
