# frozen_string_literal: true

FactoryBot.define do
  factory :scheduled_workout_exercise do
    scheduled_workout factory: %i[scheduled_workout]
    workout_day_exercise factory: %i[workout_day_exercise]
    exercise_weight_attempt factory: %i[exercise_weight_attempt]
    sets { workout_day_exercise.sets }
    reps { workout_day_exercise.reps }
    weight { workout_day_exercise.weight }
    result { Array.new(sets) { |_i| 0 } }
  end
end
