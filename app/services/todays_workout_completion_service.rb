# frozen_string_literal: true

class TodaysWorkoutCompletionService
  attr_reader :todays_workout, :workout_results, :skipped

  def initialize(todays_workout:, workout_results:, skipped: false)
    @todays_workout = todays_workout
    @workout_results = workout_results
    @skipped = skipped
  end

  def call
    return skip_todays_workout if @skipped

    process_todays_workout
  end

  private

  def skip_todays_workout
    @todays_workout.completed = true
    @todays_workout.skipped = true
    @todays_workout.save!
    true
  end

  def process_todays_workout
    scheduled_workout_exercise_ids = @workout_results.keys.map(&:to_i)
    @todays_workout.transaction do
      scheduled_workout_exercises = ScheduledWorkoutExercise
                                    .includes(:workout_day_exercise)
                                    .where(id: scheduled_workout_exercise_ids)
                                    .all

      scheduled_workout_exercises.each do |scheduled_workout_exercise|
        workout_day_exercise = scheduled_workout_exercise.workout_day_exercise
        result = @workout_results[scheduled_workout_exercise.id.to_s]['result']
        scheduled_workout_exercise.result = result

        if scheduled_workout_exercise.success?
          workout_day_exercise.increase_weight!
        elsif scheduled_workout_exercise.failure_threshold_exceeded?
          workout_day_exercise.decrease_weight!
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
