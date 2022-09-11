# frozen_string_literal: true

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

    # TODO: if active toggle has changed:
    # - set all other workouts to false
    # - set this workout to true

    @workout_day.name = name

    saved = @workout_day.save

    if saved == false
      render 'edit', status: :unprocessable_entity
    else
      flash[:notice] = 'Successfully saved'
      redirect_to(edit_workout_workout_day_path)
    end
  end

  def destroy
    params = destroy_workout_day_params
    workout_id = params[:workout_id].to_i
    workout_day_id = params[:id].to_i

    workout_day = WorkoutDay.find_by(id: workout_day_id)
    workout_day.destroy

    flash[:notice] = 'Successfully deleted workout day'

    redirect_to(edit_workout_path(workout_id))
  end

  private

  def destroy_workout_day_params
    params.permit(:id, :workout_id)
  end

  def update_workout_day_params
    params.require(:workout_day).permit(:workout, :name, :workout_day)
  end
end
