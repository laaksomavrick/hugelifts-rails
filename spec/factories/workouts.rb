# frozen_string_literal: true

workout_names = ['PPL', 'Full Body', 'Stronglifts', 'Texas Method', 'Starting Strength', 'Upper/Lower Split']

FactoryBot.define do
  factory :workout do
    name { workout_names.sample }
    active { false }
    association :user, factory: :user

    trait :with_days do
      after(:create) do |workout|
        create_list(:workout_day, 3, workout:)
      end
    end

    trait :with_days_and_exercises do
      after(:create) do |workout|
        create(:workout_day, :with_exercises, workout:, ordinal: 0)
        create(:workout_day, :with_exercises, workout:, ordinal: 1)
        create(:workout_day, :with_exercises, workout:, ordinal: 2)
      end
    end
  end
end
