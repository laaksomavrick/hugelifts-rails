# frozen_string_literal: true

class WorkoutsController < ApplicationController
  def index
    @workouts = current_user.workouts
  end

  def edit
    workout_id = params[:id]
    @workout = Workout.includes(:workout_days).find_by(id: workout_id)
  end

  def update
    params = update_workout_params
    workout_id = params[:workout].to_i
    name = params[:name]
    active = params[:active].to_i == 1

    @workout = Workout.find_by(id: workout_id)

    @workout.name = name
    @workout.active = active

    @workout.save_with_active!(user_id: current_user.id)

    flash[:notice] = 'Successfully saved'
    redirect_to(edit_workout_path(@workout.id))
  rescue ActiveRecord::RecordInvalid
    render 'edit', status: :unprocessable_entity
  end

  private

  def update_workout_params
    params.require(:workout).permit(:workout, :name, :active)
  end
end
