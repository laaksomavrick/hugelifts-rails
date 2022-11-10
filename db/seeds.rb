# frozen_string_literal: true

# rubocop:disable Style/MixinUsage
include FactoryBot::Syntax::Methods
# rubocop:enable Style/MixinUsage

user = User.create!(email: 'laakso.mavrick@gmail.com', password: 'Qweqwe1!')
active_workout = user.active_workout

active_workout.workout_days.each do |workout_day|
  create_list(:scheduled_workout, 10, :with_exercises, workout_day:, completed: true, user:)
end
