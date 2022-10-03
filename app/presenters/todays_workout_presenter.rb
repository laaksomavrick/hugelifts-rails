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

  class TodaysWorkoutExercisePresenter
    def initialize(scheduled_workout_exercise:)
      @scheduled_workout_exercise = scheduled_workout_exercise
    end

    def name
      @scheduled_workout_exercise.workout_day_exercise.exercise.name
    end

    def sets
      @scheduled_workout_exercise.sets.to_i
    end

    def reps
      @scheduled_workout_exercise.reps.to_i
    end

    def weight
      @scheduled_workout_exercise.weight.to_i
    end

    def units
      'lbs'
    end
  end
end
