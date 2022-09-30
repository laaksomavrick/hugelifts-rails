# frozen_string_literal: true

FactoryBot.define do
  factory :scheduled_workout_exercise do
    association :scheduled_workout, factory: :scheduled_workout
    association :workout_day_exercise, factory: :workout_day_exercise
    sets { Faker::Number.between(from: 3, to: 5) }
    reps { Faker::Number.between(from: 5, to: 12) }
    weight { Faker::Number.between(from: 25, to: 405) }
    result { Array.new(sets) { |_i| 0 } }
  end
end
