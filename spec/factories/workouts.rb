# frozen_string_literal: true

workout_names = ['PPL', 'Full Body', 'Stronglifts', 'Texas Method']

FactoryBot.define do
  factory :workout do
    name { workout_names.sample }
    active { false }
  end
end
