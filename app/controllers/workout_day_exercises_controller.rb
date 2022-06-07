# frozen_string_literal: true

class WorkoutDayExercisesController < ApplicationController
  def new
    workout_id = params[:workout_id]
    workout_day_id = params[:workout_day_id]

    @workout = Workout.find(workout_id)
    @workout_day = WorkoutDay.find(workout_day_id)

    @workout_day_exercise = WorkoutDayExercise.new
  end

  def create
    params = workout_day_exercise_params

    workout_id = params[:workout].to_i
    workout_day_id = params[:workout_day].to_i
    exercise_id = params[:exercise].to_i

    sets = params[:sets].to_i
    reps = params[:reps].to_i
    weight = params[:weight].to_i
    unit = params[:unit]

    @workout = Workout.find(workout_id)
    @workout_day = WorkoutDay.find(workout_day_id)
    @exercise = Exercise.find(exercise_id)

    @workout_day_exercise = WorkoutDayExercise.create(
      workout_day: @workout_day,
      exercise: @exercise,
      sets:,
      reps:,
      weight:,
      unit:
    )

    saved = @workout_day_exercise.save

    if saved == false
      render 'new', status: :unprocessable_entity
    else
      redirect_to(workout_workout_day_path(workout_id, workout_day_id))
    end
  end

  private

  def workout_day_exercise_params
    params.require(:workout_day_exercise).permit(:workout, :workout_day, :exercise, :sets, :reps, :weight, :unit)
  end
end
