class WorkoutDayExerciseForm
  include ActiveModel::Model
  attr_reader :workout_id, :workout_day_id
  delegate :errors, to: :workout_day_exercise

  def initialize(workout_id:, workout_day_id:, current_user_id:)
    @workout_id = workout_id
    @workout_day_id = workout_day_id
    @current_user_id = current_user_id
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

  attr_writer :workout_day_exercise

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

  def set_options
    [*1..5]
  end

  def default_selected_set
    4
  end

  def rep_options
    [*1..15]
  end

  def default_selected_reps
    10
  end

  def default_weight
    135
  end

  def default_unit
    ['lb']
  end

  def process(params = {})
    exercise_id = params[:exercise].to_i
    sets = params[:sets].to_i
    reps = params[:reps].to_i
    weight = params[:weight].to_i
    unit = params[:unit]

    exercise = Exercise.find(exercise_id)

    self.workout_day_exercise = WorkoutDayExercise.create(
      workout_day:,
      exercise:,
      sets:,
      reps:,
      weight:,
      unit:
    )

    workout_day_exercise.save
  end
end
