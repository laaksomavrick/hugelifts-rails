FactoryBot.define do
  factory :workout_day do
    name { Faker::Lorem.word }
    ordinal { 0 }
    association :exercise, factory: :exercise
  end
end
