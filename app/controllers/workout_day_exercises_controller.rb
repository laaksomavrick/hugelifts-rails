# frozen_string_literal: true

require_relative '../forms/workout_day_exercise_form'

class WorkoutDayExercisesController < ApplicationController
  def new
    params = new_workout_day_exercise_params
    workout_id = params[:workout_id]
    workout_day_id = params[:workout_day_id]
    current_user_id = current_user.id

    @form = WorkoutDayExerciseForm.new(workout_id:, workout_day_id:, current_user_id:)
  end

  def create
    params = create_workout_day_exercise_params

    workout_id = params[:workout].to_i
    workout_day_id = params[:workout_day].to_i
    current_user_id = current_user.id

    @form = WorkoutDayExerciseForm.new(workout_id:, workout_day_id:, current_user_id:)

    saved = @form.process(params)

    if saved == false
      render 'new', status: :unprocessable_entity
    else
      redirect_to(workout_workout_day_path(workout_id, workout_day_id))
    end
  end

  private

  def new_workout_day_exercise_params
    params.permit(:workout_id, :workout_day_id)
  end

  def create_workout_day_exercise_params
    params.require(:workout_day_exercise_form).permit(:workout, :workout_day, :exercise, :sets, :reps, :weight, :unit)
  end
end
