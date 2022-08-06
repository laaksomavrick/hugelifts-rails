# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Workout Days', type: :system do
  let!(:user) { create(:user) }
  let!(:workout) { create(:workout, user:) }
  let!(:workout_day) { create(:workout_day, workout:) }
  let!(:workout_day_exercise) { create(:workout_day_exercise, workout_day:) }

  describe 'edit page' do
    it 'redirects non-authenticated users' do
      visit edit_workout_workout_day_path(workout, workout_day)
      expect(page).to have_content('Log in')
      expect(page).to have_current_path('/users/sign_in')
    end

    it 'shows an error when name is empty' do
      sign_in user
      visit edit_workout_workout_day_path(workout, workout_day)

      fill_in 'Name', with: ''

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page).to have_content("Name can't be blank")
    end

    it 'can update a workout day' do
      sign_in user
      visit edit_workout_workout_day_path(workout, workout_day)

      fill_in 'Name', with: 'Push (A)'

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page).to have_content('Successfully saved')
    end
  end
end
