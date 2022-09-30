# frozen_string_literal: true

FactoryBot.define do
  factory :scheduled_workout do
    user factory: :user
    workout_day { create(:workout_day, :with_exercises) }
    completed { false }

    trait :with_exercises do
      after(:create) do |scheduled_workout|
        workout_day = scheduled_workout.workout_day
        workout_day_exercises = workout_day.workout_day_exercises
        workout_day_exercises.each do |wde|
          create(:scheduled_workout_exercise, exercise: wde.exercise, sets: wde.sets, reps: wde.reps,
                                              weight: wde.weight)
        end
      end
    end
  end
end
