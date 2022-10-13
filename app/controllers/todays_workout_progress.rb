# frozen_string_literal: true

module TodaysWorkoutProgress
  class TodaysWorkoutProgressState
    def initialize(todays_workout_progress:)
      @todays_workout_progress = todays_workout_progress || {}
    end

    def exercise_progress(exercise_id:)
      exercise_id = exercise_id.to_s
      @todays_workout_progress[exercise_id]
    end
  end

  def todays_workout_progress
    todays_workout_progress = session[:todays_workout_progress]
    TodaysWorkoutProgressState.new(todays_workout_progress:)
  end

  def set_progress(exercise_id:, ordinal:, reps:)
    exercise_id = exercise_id.to_s
    ordinal = ordinal.to_s
    reps = reps.to_s
    session[:todays_workout_progress][exercise_id] ||= {}
    session[:todays_workout_progress][exercise_id][ordinal] = reps
  end

  def destroy_progress
    session[:todays_workout_progress] = nil
  end

  def set_todays_workout_progress_session
    session[:todays_workout_progress] ||= {}
  end
end
