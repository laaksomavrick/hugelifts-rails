# frozen_string_literal: true

class WorkoutDayExercisesController < ApplicationController
  def new
    workout_id = params[:workout_id]
    workout_day_id = params[:workout_day_id]

    @workout = Workout.find(workout_id)
    @workout_day = WorkoutDay.find(workout_day_id)

    @exercises = current_user.exercises.map { |e| [e.name, e.id ]}
    @sets = [*1..5]
    @reps = [*1..15]
  end

  def create

  end

  private

  def new_workout_day_exercise_params
  end
end
