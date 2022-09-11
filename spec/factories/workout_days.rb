# frozen_string_literal: true

FactoryBot.define do
  factory :workout_day do
    name { Faker::Lorem.word }
    ordinal { 0 }
    association :workout, factory: :workout

    trait :with_exercises do
      after(:create) do |workout_day|
        create_list(:workout_day_exercise, 4, workout_day:)
      end
    end
  end
end
