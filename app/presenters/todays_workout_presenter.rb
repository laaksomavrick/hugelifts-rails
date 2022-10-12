# frozen_string_literal: true

class TodaysWorkoutPresenter
  def initialize(scheduled_workout:, todays_workout_state:)
    @scheduled_workout = scheduled_workout
    @todays_workout_state = todays_workout_state || {}
  end

  def workout?
    @scheduled_workout.present?
  end

  def day_name
    @scheduled_workout.workout_day.name
  end

  def exercises
    @scheduled_workout.exercises.map do |scheduled_workout_exercise|
      id = scheduled_workout_exercise.id
      exercise_state = @todays_workout_state[id.to_s]
      TodaysWorkoutExercisePresenter.new(scheduled_workout_exercise:, exercise_state:)
    end
  end

  def id
    @scheduled_workout.id
  end

  class TodaysWorkoutExercisePresenter
    attr_reader :scheduled_workout_exercise

    def initialize(scheduled_workout_exercise:, exercise_state:)
      @scheduled_workout_exercise = scheduled_workout_exercise
      @exercise_state = exercise_state
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
      (@exercise_state && @exercise_state[ordinal.to_s]) || reps
    end

    def active(ordinal)
      if @exercise_state && @exercise_state[ordinal.to_s]
        @exercise_state[ordinal.to_s] ? '1' : '0'
      else
        '0'
      end
    end
  end
end
