# frozen_string_literal: true

FactoryBot.define do
  factory :exercise_weight_attempt do
    workout_day_exercise factory: :workout_day_exercise
    weight { workout_day_exercise.weight }
  end
end
