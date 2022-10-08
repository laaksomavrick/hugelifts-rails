# frozen_string_literal: true

class TodaysWorkoutCompletionService
  attr_reader :todays_workout, :workout_results

  def initialize(todays_workout:, workout_results:)
    @todays_workout = todays_workout
    @workout_results = workout_results
  end

  def call
    # TODO: test
    # - updates all results
    # - if success, weight is increased
    # - completed is set to true

    scheduled_workout_exercise_ids = @workout_results.keys.map(&:to_i)

    @todays_workout.transaction do
      scheduled_workout_exercises = ScheduledWorkoutExercise
                                    .includes(:workout_day_exercise)
                                    .where(id: scheduled_workout_exercise_ids)
                                    .all

      scheduled_workout_exercises.each do |scheduled_workout_exercise|
        result = @workout_results[scheduled_workout_exercise.id.to_s]['result']
        scheduled_workout_exercise.result = result

        if scheduled_workout_exercise.success?
          scheduled_workout_exercise.workout_day_exercise.increase_weight!
          scheduled_workout_exercise.workout_day_exercise.save!
        end

        scheduled_workout_exercise.save!
      end

      @todays_workout.completed = true
      @todays_workout.save!

      true
    rescue StandardError => e
      Rails.logger.error e.message
      false
    end
  end
end