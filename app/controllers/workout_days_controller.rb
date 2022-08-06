# frozen_string_literal: true

#
# TODO: authorization logic (e.g. policy on this resource) with pundit

class WorkoutDaysController < ApplicationController
  def edit
    workout_day_id = params[:id]
    @workout_day = WorkoutDay.includes(workout_day_exercises: :exercise).find_by(id: workout_day_id)
    @workout = @workout_day.workout
  end

  def update
    params = update_workout_day_params

    workout_day_id = params[:workout_day].to_i
    name = params[:name]

    @workout_day = WorkoutDay.find_by(id: workout_day_id)
    @workout = @workout_day.workout

    @workout_day.name = name

    saved = @workout_day.save

    if saved == false
      render 'edit', status: :unprocessable_entity
    else
      flash[:notice] = 'Successfully saved.'
      redirect_to(workout_workout_day_path)
    end
  end

  private

  def update_workout_day_params
    params.require(:workout_day).permit(:workout, :name, :workout_day)
  end
end
