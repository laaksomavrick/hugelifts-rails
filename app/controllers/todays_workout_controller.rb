# frozen_string_literal: true

class TodaysWorkoutController < ApplicationController
  def index
    policy_scope(ScheduledWorkout)
    scheduled_workout = TodaysWorkoutService.new(user: current_user).call
    @todays_workout = TodaysWorkoutPresenter.new(scheduled_workout:)
  end

  def update
    todays_workout_id = params[:id]
    scheduled_workout_exercise_form_results = params[:scheduled_workout_exercises]

    # TODO: extract to service object

    scheduled_workout_exercise_ids = scheduled_workout_exercise_form_results.keys.map(&:to_i)

    todays_workout = ScheduledWorkout.find_by(id: todays_workout_id)

    todays_workout.transaction do
      scheduled_workout_exercises = ScheduledWorkoutExercise
                                    .includes(:workout_day_exercise)
                                    .where(id: scheduled_workout_exercise_ids)
                                    .all

      scheduled_workout_exercises.each do |scheduled_workout_exercise|
        result = scheduled_workout_exercise_form_results[scheduled_workout_exercise.id.to_s]['result']
        scheduled_workout_exercise.result = result

        if scheduled_workout_exercise.success?
          scheduled_workout_exercise.workout_day_exercise.increase_weight!
          scheduled_workout_exercise.workout_day_exercise.save!
        end

        scheduled_workout_exercise.save!
      end

      todays_workout.completed = true
      todays_workout.save!
    end

    redirect_to(todays_workout_index_path)
  end

  private

  def update_todays_workout_params
    params.require(:scheduled_workout_exercises)
  end
end
