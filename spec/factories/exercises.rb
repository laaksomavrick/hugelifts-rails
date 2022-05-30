# frozen_string_literal: true

FactoryBot.define do
  factory :exercise do
    user factory: :user
    name { Exercise.default_exercises.sample }
  end
end
