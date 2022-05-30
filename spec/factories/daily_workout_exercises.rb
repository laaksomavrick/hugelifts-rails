# frozen_string_literal: true

FactoryBot.define do
  factory :daily_workout_exercise do
    exercise factory: :exercise
    workout_day factory: :workout_day
    sets { Faker::Number.between(from: 3, to: 5) }
    reps { Faker::Number.between(from: 5, to: 12) }
    weight { Faker::Number.between(from: 25, to: 405) }
    unit { 'lb' }
  end
end
