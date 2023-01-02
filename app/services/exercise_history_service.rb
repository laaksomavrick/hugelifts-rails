# frozen_string_literal: true

class ExerciseHistoryService
  class ExerciseHistoryEntry
    attr_reader :name, :date, :one_rep_max, :id

    def initialize(exercise:, scheduled_workout_exercise:)
      @name = exercise.name
      @date = scheduled_workout_exercise.updated_at
      @one_rep_max = calculate_one_rep_max(scheduled_workout_exercise)
      @id = scheduled_workout_exercise.id
    end

    private

    def calculate_one_rep_max(scheduled_workout_exercise)
      # https://en.wikipedia.org/wiki/One-repetition_maximum
      # Epley formula
      weight = scheduled_workout_exercise.weight
      reps = scheduled_workout_exercise.result.max

      actual = (weight * (1 + (reps.to_f / 30.0)))
      remainder = actual % 5
      (actual - remainder).to_i
    end
  end

  def initialize(user:, exercise:)
    @user = user
    @exercise = exercise
  end

  def call
    ScheduledWorkoutExercise
      .not_skipped
      .completed
      .joins(:scheduled_workout, workout_day_exercise: :exercise)
      .where('scheduled_workout.user_id': @user.id)
      .where('exercise.id': @exercise.id)
      .order(created_at: :asc)
      .limit(10)
      .all
      .map do |scheduled_workout_exercise|
      ExerciseHistoryEntry.new(exercise: @exercise,
                               scheduled_workout_exercise:)
    end
  end
end
