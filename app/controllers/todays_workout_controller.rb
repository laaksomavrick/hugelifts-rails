# frozen_string_literal: true
#
# TODO: on completion of an exercise, increase the weight

class TodaysWorkoutController < ApplicationController
  def index
    # policy_scope(nil, policy_scope_class: TodaysWorkoutPolicy::Scope)
    # Find the appropriate scheduled_workout
    # If none exists, create from ordinal 0 of the active workout
    # If some exist:
    #   If one is incomplete, return that
    #   If none are incomplete, find the latest completion ordinal and create from ordinal + 1 (cycle)

    # TODO: transaction

    has_scheduled_workout = current_user.scheduled_workouts.any?
    active_workout = current_user.workouts.active_workout_for_user(current_user)
    active_workout_days = active_workout.days
    active_workout_day_ids = active_workout_days.map(&:id)

    if has_scheduled_workout == false
      to_schedule_workout_day = active_workout_days.order(ordinal: :asc).first

      # TODO: dry
      todays_workout = ScheduledWorkout.new(completed: false, workout_day: to_schedule_workout_day, user: current_user)
      todays_workout.save!

      to_schedule_workout_day.exercises.each do |exercise|
        scheduled_exercise = ScheduledWorkoutExercise.new(
          sets: exercise.sets,
          reps: exercise.reps,
          weight: exercise.weight,
          result: [],
          scheduled_workout: todays_workout,
          workout_day_exercise: exercise
        )
        scheduled_exercise.save!
      end

      @todays_workout = ScheduledWorkout.includes(:scheduled_workout_exercises).find(todays_workout.id)
    else
      incomplete_workout = current_user.scheduled_workouts
                                       .includes(:scheduled_workout_exercises)
                                       .where(completed: false, workout_day: [active_workout_day_ids])
                                       .first

      if incomplete_workout.present?
        @todays_workout = incomplete_workout
      else
        last_completed_workout = current_user.scheduled_workouts
                                             .includes(:workout_day)
                                             .where(completed: true, workout_day: [active_workout_day_ids])
                                             .order(created_at: :desc)
                                             .first
        ordinals = last_completed_workout.workout_day.workout.workout_days.order(ordinal: :asc).map(&:ordinal)
        last_completed_ordinal = last_completed_workout.workout_day.ordinal
        next_ordinal = last_completed_ordinal == ordinals.last ? ordinals.first : last_completed_ordinal + 1
        next_workout_day = active_workout_days.where(ordinal: next_ordinal).first

        # TODO: DRY
        todays_workout = ScheduledWorkout.new(completed: false, workout_day: next_workout_day, user: current_user)
        todays_workout.save!

        next_workout_day.exercises.each do |exercise|
          scheduled_exercise = ScheduledWorkoutExercise.new(
            sets: exercise.sets,
            reps: exercise.reps,
            weight: exercise.weight,
            result: [],
            scheduled_workout: todays_workout,
            workout_day_exercise: exercise
          )
          scheduled_exercise.save!
        end

        @todays_workout = ScheduledWorkout.includes(:scheduled_workout_exercises).find(todays_workout.id)
      end
    end
  end
end
