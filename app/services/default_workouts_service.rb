# frozen_string_literal: true

class DefaultWorkoutsService
  def initialize(user:)
    @user = user
  end

  def call
    exercises = Exercise.all
    stronglifts = create_stronglifts_5x5(exercises:)
    ppl = create_ppl(exercises:)
    [ppl, stronglifts]
  end

  private

  def create_ppl(exercises:)
    Workout.transaction do
      bench_press = exercises.find { |x| x.name == Exercise::BARBELL_BENCH_PRESS }
      overhead_press = exercises.find { |x| x.name == Exercise::SEATED_BARBELL_OVERHEAD_PRESS }
      incline_bench_press = exercises.find { |x| x.name == Exercise::INCLINE_BARBELL_BENCH_PRESS }
      skullcrusher = exercises.find { |x| x.name == Exercise::SKULLCRUSHER }
      lateral_raises = exercises.find { |x| x.name == Exercise::LATERAL_RAISE }

      barbell_row = exercises.find { |x| x.name == Exercise::BARBELL_ROW }
      pendlay_row = exercises.find { |x| x.name == Exercise::PENDLAY_ROW }
      chinup = exercises.find { |x| x.name == Exercise::CHINUP }
      dumbbell_row = exercises.find { |x| x.name == Exercise::DUMBBELL_ROW }
      pullup = exercises.find { |x| x.name == Exercise::PULLUP }
      shrugs = exercises.find { |x| x.name == Exercise::BARBELL_SHRUG }
      ez_curl = exercises.find { |x| x.name == Exercise::EZ_BAR_BICEP_CURL }

      squat = exercises.find { |x| x.name == Exercise::BACK_SQUAT }
      deadlift = exercises.find { |x| x.name == Exercise::DEADLIFT }
      romanian_deadlift = exercises.find { |x| x.name == Exercise::ROMANIAN_DEADLIFT }
      hip_trust = exercises.find { |x| x.name == Exercise::HIP_THRUST }

      workout = Workout.create!(name: 'PPL', active: true, user: @user)

      push_day_a = WorkoutDay.create!(workout:, ordinal: 0, name: 'Push A')
      pull_day_a = WorkoutDay.create!(workout:, ordinal: 1, name: 'Pull A')
      leg_day_a = WorkoutDay.create!(workout:, ordinal: 2, name: 'Legs A')
      push_day_b = WorkoutDay.create!(workout:, ordinal: 3, name: 'Push B')
      pull_day_b = WorkoutDay.create!(workout:, ordinal: 4, name: 'Pull B')
      leg_day_b = WorkoutDay.create!(workout:, ordinal: 5, name: 'Legs B')

      WorkoutDayExercise.create!(workout_day: push_day_a, exercise: bench_press,
                                 meta: { 'sets' => 4, 'reps' => 10, 'weight' => 155, unit: 'lb' })
      WorkoutDayExercise.create!(workout_day: push_day_a, exercise: incline_bench_press,
                                 meta: { 'sets' => 4, 'reps' => 10, 'weight' => 135, unit: 'lb' })
      WorkoutDayExercise.create!(workout_day: push_day_a, exercise: overhead_press,
                                 meta: { 'sets' => 4, 'reps' => 10, 'weight' => 95, unit: 'lb' })
      WorkoutDayExercise.create!(workout_day: push_day_a, exercise: skullcrusher,
                                 meta: { 'sets' => 4, 'reps' => 10, 'weight' => 80, unit: 'lb' })

      WorkoutDayExercise.create!(workout_day: pull_day_a, exercise: pendlay_row,
                                 meta: { 'sets' => 5, 'reps' => 5, 'weight' => 200, unit: 'lb' })
      WorkoutDayExercise.create!(workout_day: pull_day_a, exercise: chinup,
                                 meta: { 'sets' => 4, 'reps' => 10, 'weight' => 30, unit: 'lb' })
      WorkoutDayExercise.create!(workout_day: pull_day_a, exercise: dumbbell_row,
                                 meta: { 'sets' => 4, 'reps' => 10, 'weight' => 80, unit: 'lb' })
      WorkoutDayExercise.create!(workout_day: pull_day_a, exercise: ez_curl,
                                 meta: { 'sets' => 4, 'reps' => 10, 'weight' => 90, unit: 'lb' })

      WorkoutDayExercise.create!(workout_day: leg_day_a, exercise: squat,
                                 meta: { 'sets' => 5, 'reps' => 5, 'weight' => 200, unit: 'lb' })
      WorkoutDayExercise.create!(workout_day: leg_day_a, exercise: romanian_deadlift,
                                 meta: { 'sets' => 4, 'reps' => 10, 'weight' => 190, unit: 'lb' })
      WorkoutDayExercise.create!(workout_day: leg_day_a, exercise: hip_trust,
                                 meta: { 'sets' => 4, 'reps' => 10, 'weight' => 180, unit: 'lb' })

      WorkoutDayExercise.create!(workout_day: push_day_b, exercise: overhead_press,
                                 meta: { 'sets' => 5, 'reps' => 5, 'weight' => 135, unit: 'lb' })
      WorkoutDayExercise.create!(workout_day: push_day_b, exercise: incline_bench_press,
                                 meta: { 'sets' => 4, 'reps' => 10, 'weight' => 135, unit: 'lb' })
      WorkoutDayExercise.create!(workout_day: push_day_b, exercise: skullcrusher,
                                 meta: { 'sets' => 4, 'reps' => 10, 'weight' => 80, unit: 'lb' })
      WorkoutDayExercise.create!(workout_day: push_day_b, exercise: lateral_raises,
                                 meta: { 'sets' => 4, 'reps' => 15, 'weight' => 15, unit: 'lb' })

      WorkoutDayExercise.create!(workout_day: pull_day_b, exercise: pullup,
                                 meta: { 'sets' => 4, 'reps' => 10, 'weight' => 35, unit: 'lb' })
      WorkoutDayExercise.create!(workout_day: pull_day_b, exercise: barbell_row,
                                 meta: { 'sets' => 4, 'reps' => 10, 'weight' => 155, unit: 'lb' })
      WorkoutDayExercise.create!(workout_day: pull_day_b, exercise: ez_curl,
                                 meta: { 'sets' => 4, 'reps' => 10, 'weight' => 90, unit: 'lb' })
      WorkoutDayExercise.create!(workout_day: pull_day_b, exercise: shrugs,
                                 meta: { 'sets' => 4, 'reps' => 10, 'weight' => 225, unit: 'lb' })

      WorkoutDayExercise.create!(workout_day: leg_day_b, exercise: deadlift,
                                 meta: { 'sets' => 3, 'reps' => 5, 'weight' => 315, unit: 'lb' })
      WorkoutDayExercise.create!(workout_day: leg_day_b, exercise: squat,
                                 meta: { 'sets' => 5, 'reps' => 5, 'weight' => 155, unit: 'lb' })
      WorkoutDayExercise.create!(workout_day: leg_day_b, exercise: hip_trust,
                                 meta: { 'sets' => 4, 'reps' => 10, 'weight' => 180, unit: 'lb' })

      workout
    end
  end

  def create_stronglifts_5x5(exercises:)
    Workout.transaction do
      squat = exercises.find { |x| x.name == Exercise::BACK_SQUAT }
      bench_press = exercises.find { |x| x.name == Exercise::BARBELL_BENCH_PRESS }
      barbell_row = exercises.find { |x| x.name == Exercise::BARBELL_ROW }
      overhead_press = exercises.find { |x| x.name == Exercise::BARBELL_OVERHEAD_PRESS }
      deadlift = exercises.find { |x| x.name == Exercise::DEADLIFT }
      meta = { 'sets' => 5, 'reps' => 5,
               'weight' => 135, unit: 'lb' }

      workout = Workout.create!(name: 'Stronglifts 5x5', active: false, user: @user)

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
