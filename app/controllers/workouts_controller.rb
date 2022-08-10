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

    @workout = Workout.find_by(id: workout_id)
    @workout.name = name

    saved = @workout.save

    if saved == false
      render 'edit', status: :unprocessable_entity
    else
      flash[:notice] = 'Successfully saved'
      redirect_to(edit_workout_path(@workout.id))
    end
  end

  private

  def update_workout_params
    params.require(:workout).permit(:workout, :name)
  end
end
