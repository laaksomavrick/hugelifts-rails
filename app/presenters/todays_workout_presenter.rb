# frozen_string_literal: true

class TodaysWorkoutPresenter
  def initialize(scheduled_workout:, todays_workout_progress:)
    @scheduled_workout = scheduled_workout
    @todays_workout_progress = todays_workout_progress
  end

  def workout?
    @scheduled_workout.present?
  end

  def day_name
    @scheduled_workout.workout_day.name
  end

  def exercises
    @scheduled_workout.exercises.map do |scheduled_workout_exercise|
      exercise_id = scheduled_workout_exercise.id
      exercise_progress = @todays_workout_progress.exercise_progress(exercise_id:)
      TodaysWorkoutExercisePresenter.new(scheduled_workout_exercise:, exercise_progress:)
    end
  end

  def id
    @scheduled_workout.id
  end

  def skipped?
    @todays_workout_progress.skipped?
  end

  class TodaysWorkoutExercisePresenter
    attr_reader :scheduled_workout_exercise

    def initialize(scheduled_workout_exercise:, exercise_progress:)
      @scheduled_workout_exercise = scheduled_workout_exercise
      @exercise_progress = exercise_progress
    end

    def name
      @scheduled_workout_exercise.workout_day_exercise.exercise.name
    end

    def sets
      @scheduled_workout_exercise.sets
    end

    def reps
      @scheduled_workout_exercise.reps
    end

    def weight
      @scheduled_workout_exercise.weight
    end

    def id
      @scheduled_workout_exercise.id
    end

    def units
      'lbs'
    end

    def default_result
      @scheduled_workout_exercise.empty_result
    end

    def reps_for_ordinal(ordinal)
      ordinal = ordinal.to_s
      (@exercise_progress && @exercise_progress[ordinal]) || reps
    end

    def active(ordinal)
      ordinal = ordinal.to_s
      if @exercise_progress && @exercise_progress[ordinal]
        @exercise_progress[ordinal] ? '1' : '0'
      else
        '0'
      end
    end

    def in_danger?
      @scheduled_workout_exercise.failure_threshold_exceedable?
    end
  end
end
