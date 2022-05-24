# frozen_string_literal: true

class WorkoutsController < ApplicationController
  def index
    @workouts = current_user.workouts
  end

  def show
    workout_id = params[:id]
    @workout = Workout.find_by(id: workout_id)
  end
end
