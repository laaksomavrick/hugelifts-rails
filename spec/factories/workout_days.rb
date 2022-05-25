# frozen_string_literal: true

FactoryBot.define do
  factory :workout_day do
    name { Faker::Lorem.word }
    ordinal { 0 }
    association :workout, factory: :workout
  end
end
