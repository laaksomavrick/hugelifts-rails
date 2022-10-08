# frozen_string_literal: true

class TodaysWorkoutPresenter
  def initialize(scheduled_workout:)
    @scheduled_workout = scheduled_workout
  end

  def workout?
    @scheduled_workout.present?
  end

  def day_name
    @scheduled_workout.workout_day.name
  end

  def exercises
    @scheduled_workout.exercises.map do |scheduled_workout_exercise|
      TodaysWorkoutExercisePresenter.new(scheduled_workout_exercise:)
    end
  end

  def id
    @scheduled_workout.id
  end

  class TodaysWorkoutExercisePresenter
    attr_reader :scheduled_workout_exercise

    def initialize(scheduled_workout_exercise:)
      @scheduled_workout_exercise = scheduled_workout_exercise
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
  end
end
