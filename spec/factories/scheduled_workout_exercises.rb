# frozen_string_literal: true

FactoryBot.define do
  factory :scheduled_workout_exercise do
    association :scheduled_workout, factory: :scheduled_workout
    association :workout_day_exercise, factory: :workout_day_exercise
    association :exercise_weight_attempt, factory: :exercise_weight_attempt
    sets { workout_day_exercise.sets }
    reps { workout_day_exercise.reps }
    weight { workout_day_exercise.weight }
    result { Array.new(sets) { |_i| 0 } }
  end
end
