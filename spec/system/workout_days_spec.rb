# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Workout Days', type: :system do
  let!(:user) { create(:user) }
  let!(:workout) { create(:workout, user:) }
  let!(:workout_day) { create(:workout_day, workout:) }
  let!(:workout_day_exercise) { create(:workout_day_exercise, workout_day:) }

  describe 'show page' do
    it 'redirects non-authenticated users' do
      visit workout_workout_day_path(workout, workout_day)
      expect(page).to have_content('Log in')
      expect(page).to have_current_path('/users/sign_in')
    end

    it 'shows a workout\'s days' do
      sign_in user
      visit workout_workout_day_path(workout, workout_day)
      expect(page).to have_current_path("/workouts/#{workout.id}/days/#{workout_day.id}")
      expect(page).to have_content(workout_day.name)
      expect(page).to have_content(workout_day_exercise.exercise.name)
    end
  end
end