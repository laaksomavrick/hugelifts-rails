# frozen_string_literal: true

class DefaultWorkoutsService
  def initialize(user:)
    @user = user
  end

  def call
    exercises = Exercise.all
    stronglifts = create_stronglifts_5x5(exercises:)
    [stronglifts]
  end

  private

  def create_ppl; end

  def create_stronglifts_5x5(exercises:)
    Workout.transaction do
      squat = exercises.find { |x| x.name == Exercise::BACK_SQUAT }
      bench_press = exercises.find { |x| x.name == Exercise::BARBELL_BENCH_PRESS }
      barbell_row = exercises.find { |x| x.name == Exercise::BARBELL_ROW }
      overhead_press = exercises.find { |x| x.name == Exercise::BARBELL_OVERHEAD_PRESS }
      deadlift = exercises.find { |x| x.name == Exercise::DEADLIFT }
      meta = { 'sets' => 5, 'reps' => 5,
               'weight' => 135, unit: 'lb' }

      workout = Workout.create!(name: 'Stronglifts 5x5', active: true, user: @user)

      a_day = WorkoutDay.create!(workout:, ordinal: 0, name: 'A')
      b_day = WorkoutDay.create!(workout:, ordinal: 1, name: 'B')

      WorkoutDayExercise.create!(workout_day: a_day, exercise: squat, meta:)
      WorkoutDayExercise.create!(workout_day: a_day, exercise: bench_press, meta:)
      WorkoutDayExercise.create!(workout_day: a_day, exercise: barbell_row, meta:)

      WorkoutDayExercise.create!(workout_day: b_day, exercise: squat, meta:)
      WorkoutDayExercise.create!(workout_day: b_day, exercise: overhead_press, meta:)
      WorkoutDayExercise.create!(workout_day: b_day, exercise: deadlift, meta:)

      workout
    end
  end
end
