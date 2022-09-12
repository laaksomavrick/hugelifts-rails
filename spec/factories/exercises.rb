# frozen_string_literal: true

FactoryBot.define do
  factory :exercise do
    user factory: :user
    name { Exercise::DEFAULT_EXERCISE_NAMES.sample }
  end
end
