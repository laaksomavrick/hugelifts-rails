# frozen_string_literal: true

class WorkoutDayExerciseForm
  include ActiveModel::Model
  attr_reader :workout_id, :workout_day_id, :workout_day_exercise_id

  delegate :errors, to: :workout_day_exercise

  def initialize(workout_id:, workout_day_id:, current_user_id:, workout_day_exercise: nil)
    @workout_id = workout_id
    @workout_day_id = workout_day_id
    @current_user_id = current_user_id
    @workout_day_exercise = workout_day_exercise
    @workout_day_exercise_id = workout_day_exercise&.id
  end

  def workout
    @workout ||= Workout.find(@workout_id)
  end

  def workout_day
    @workout_day ||= WorkoutDay.find(@workout_day_id)
  end

  def user
    @user ||= User.find(@current_user_id)
  end

  def workout_day_exercise
    @workout_day_exercise ||= WorkoutDayExercise.new
  end

  def workout_options
    [[workout.name, workout.id]]
  end

  def workout_day_options
    [[workout_day.name, workout_day.id]]
  end

  def exercise_options
    exercises = user.exercises
    exercises.map { |e| [e.name, e.id] }
  end

  def selected_exercise
    return exercise_options.first if @workout_day_exercise.exercise.nil?

    exercise = @workout_day_exercise.exercise
    exercise.id
  end

  def set_options
    [*1..5]
  end

  def selected_sets
    return 4 if @workout_day_exercise.exercise.nil?

    @workout_day_exercise.sets
  end

  def rep_options
    [*1..15]
  end

  def selected_reps
    return 10 if @workout_day_exercise.exercise.nil?

    @workout_day_exercise.reps
  end

  def selected_weight
    return 135 if @workout_day_exercise.exercise.nil?

    @workout_day_exercise.weight
  end

  def default_unit
    ['lb']
  end

  def ordinal
    return @workout_day.exercises.count if new?

    @workout_day_exercise.ordinal
  end

  def ordinal_options
    max_ordinal = if new?
                    @workout_day.exercises.count
                  else
                    @workout_day.exercises.count - 1
                  end
    [*0..max_ordinal]
  end

  def process(params = {})
    exercise_id = params[:exercise].to_i
    sets = params[:sets].to_i
    reps = params[:reps].to_i
    weight = params[:weight].to_i
    unit = params[:unit]
    ordinal = params[:ordinal].to_i

    WorkoutDayExercise.transaction do
      exercise = Exercise.find(exercise_id)

      if @workout_day_exercise_id
        @workout_day_exercise.update(
          exercise:,
          sets:,
          reps:,
          weight:,
          unit:
        )
      else
        @workout_day_exercise = WorkoutDayExercise.create(
          workout_day:,
          exercise:,
          sets:,
          reps:,
          weight:,
          unit:
        )
      end

      @workout_day_exercise.insert_at(ordinal)

      @workout_day_exercise.exercise_weight_attempts.create(weight:)
    end

    @workout_day_exercise
  end

  private

  def new?
    workout_day_exercise.id.nil?
  end
end
