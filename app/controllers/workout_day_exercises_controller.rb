# frozen_string_literal: true

class WorkoutDayExercisesController < ApplicationController
  def new
    params = new_workout_day_exercise_params
    workout_id = params[:workout_id]
    workout_day_id = params[:workout_day_id]
    current_user_id = current_user.id

    authorize WorkoutDayExercise

    @form = WorkoutDayExerciseForm.new(workout_id:, workout_day_id:, current_user_id:)
  end

  def edit
    params = edit_workout_day_exercise_params
    workout_id = params[:workout_id]
    workout_day_id = params[:workout_day_id]
    workout_day_exercise_id = params[:id]
    current_user_id = current_user.id

    workout_day_exercise = authorize WorkoutDayExercise.find(workout_day_exercise_id)

    @form = WorkoutDayExerciseForm.new(workout_id:, workout_day_id:, current_user_id:, workout_day_exercise:)
  end

  def create
    params = create_workout_day_exercise_params

    workout_id = params[:workout].to_i
    workout_day_id = params[:workout_day].to_i
    current_user_id = current_user.id

    @form = WorkoutDayExerciseForm.new(workout_id:, workout_day_id:, current_user_id:)

    authorize WorkoutDayExercise

    saved = @form.process(params)

    if saved == false
      render 'new', status: :unprocessable_entity
    else
      redirect_to(edit_workout_workout_day_path(workout_id, workout_day_id))
    end
  end

  def update
    params = update_workout_day_exercise_params

    workout_id = params[:workout].to_i
    workout_day_id = params[:workout_day].to_i
    workout_day_exercise_id = params[:workout_day_exercise].to_i
    current_user_id = current_user.id

    workout_day_exercise = authorize WorkoutDayExercise.find(workout_day_exercise_id)
    @form = WorkoutDayExerciseForm.new(workout_id:, workout_day_id:, current_user_id:, workout_day_exercise:)

    saved = @form.process(params)

    if saved == false
      render 'new', status: :unprocessable_entity
    else
      flash[:notice] = t('.success')
      redirect_to(edit_workout_workout_day_path(workout_id, workout_day_id))
    end
  end

  def destroy
    params = destroy_workout_day_exercise_params
    workout_id = params[:workout_id].to_i
    workout_day_id = params[:workout_day_id].to_i
    workout_day_exercise_id = params[:id].to_i

    workout_day_exercise = authorize WorkoutDayExercise.find(workout_day_exercise_id)

    workout_day_exercise.destroy

    flash[:notice] = "Successfully deleted #{workout_day_exercise.exercise.name}"
    redirect_to(edit_workout_workout_day_path(workout_id, workout_day_id))
  end

  private

  def new_workout_day_exercise_params
    params.permit(:workout_id, :workout_day_id)
  end

  def edit_workout_day_exercise_params
    params.permit(:workout_id, :workout_day_id, :id)
  end

  def create_workout_day_exercise_params
    params.require(:workout_day_exercise_form).permit(:workout, :workout_day, :exercise, :sets, :reps, :weight, :unit,
                                                      :ordinal)
  end

  def update_workout_day_exercise_params
    params.require(:workout_day_exercise_form).permit(:workout, :workout_day, :workout_day_exercise, :exercise, :sets,
                                                      :reps, :weight, :unit, :ordinal)
  end

  def destroy_workout_day_exercise_params
    params.permit(:workout_id, :workout_day_id, :id)
  end
end
