# frozen_string_literal: true

class TodaysWorkoutService
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def call
    ScheduledWorkout.transaction do
      active_workout = @user.workouts.active_workout_for_user(@user)

      raise "No active workout for user=#{@user.id}" if active_workout.blank?

      active_workout_days = active_workout.days
      active_workout_day_ids = active_workout_days.map(&:id)

      scheduled_workout = scheduled_workout(active_workout_day_ids:)
      incomplete_workout = incomplete_workout(active_workout_day_ids:)
      last_completed_workout = last_completed_workout(active_workout_day_ids:)

      if scheduled_workout.none?
        to_schedule_workout_day = active_workout_days.order(ordinal: :asc).first
        generate_todays_workout(workout_day: to_schedule_workout_day)
      elsif incomplete_workout.present?
        incomplete_workout
      elsif last_completed_workout.present?
        ordinals = last_completed_workout.workout_day.workout.workout_days.order(ordinal: :asc).map(&:ordinal)
        last_completed_ordinal = last_completed_workout.workout_day.ordinal
        next_ordinal = last_completed_ordinal == ordinals.last ? ordinals.first : last_completed_ordinal + 1

        next_workout_day = active_workout_days.where(ordinal: next_ordinal).first
        generate_todays_workout(workout_day: next_workout_day)
      else
        raise "Something unexpected went wrong generating a scheduled_workout for workout=#{active_workout.id}"
      end
    end
  rescue StandardError
    nil
  end

  private

  def last_completed_workout(active_workout_day_ids:)
    @user.scheduled_workouts
         .includes(:workout_day)
         .where(completed: true, workout_day: [active_workout_day_ids])
         .order(created_at: :desc)
         .first
  end

  def incomplete_workout(active_workout_day_ids:)
    @user.scheduled_workouts
         .with_exercises
         .where(completed: false, workout_day: [active_workout_day_ids])
         .first
  end

  def scheduled_workout(active_workout_day_ids:)
    @user.scheduled_workouts.where(workout_day_id: [active_workout_day_ids])
  end

  def generate_todays_workout(workout_day:)
    todays_workout = ScheduledWorkout.new(completed: false, workout_day:, user: @user)
    todays_workout.save!

    workout_day.exercises.each do |exercise|
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

    # :scheduled_workout_exercises, :workout_day
    ScheduledWorkout.with_exercises.find(todays_workout.id)
  end
end
