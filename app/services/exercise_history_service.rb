# frozen_string_literal: true

class ExerciseHistoryService
  class ExerciseHistoryEntry
    def initialize(exercise:, scheduled_workout_exercise:)
      @exercise = exercise
      @scheduled_workout_exercise = scheduled_workout_exercise
    end

    def name
      @exercise.name
    end

    def date
      @scheduled_workout_exercise.updated_at
    end

    def one_rep_max
      # https://en.wikipedia.org/wiki/One-repetition_maximum
      # Epley formula
      weight = @scheduled_workout_exercise.weight
      reps = @scheduled_workout_exercise.result.max

      weight * (1 + (reps.to_f / 30.0))
    end
  end

  def initialize(user:, exercise:)
    @user = user
    @exercise = exercise
  end

  def call
    ScheduledWorkoutExercise
      .joins(:scheduled_workout, workout_day_exercise: :exercise)
      .where('scheduled_workout.completed': true)
      .where('scheduled_workout.user_id': @user.id)
      .where('exercise.id': @exercise.id)
      .order(created_at: :asc)
      .all
      .map do |scheduled_workout_exercise|
      ExerciseHistoryEntry.new(exercise: @exercise,
                               scheduled_workout_exercise:)
    end
  end
end
