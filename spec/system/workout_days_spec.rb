# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Workout Days', type: :system do
  let!(:user) { create(:user) }
  let!(:workout) { user.workouts.first }
  let!(:workout_day) { workout.workout_days.first }

  describe 'new page' do
    it 'redirects non-authenticated users' do
      visit new_workout_workout_day_path(workout)
      expect(page).to have_content('Log in')
      expect(page).to have_current_path('/users/sign_in')
    end

    it 'shows an error when name is empty' do
      sign_in user
      visit new_workout_workout_day_path(workout, workout_day)

      fill_in 'Name', with: ''

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page).to have_content("Name can't be blank")
    end

    it 'can create a workout day' do
      sign_in user
      visit new_workout_workout_day_path(workout, workout_day)

      workout_day_name = 'Workout day name'

      fill_in 'Name', with: workout_day_name

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page).to have_content('Successfully saved')
      expect(page).to have_content(workout_day_name)
    end
  end

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
      expect(find_field('Name').value).to eq 'Push (A)'
    end

    it 'can delete a workout day' do
      sign_in user
      visit edit_workout_workout_day_path(workout, workout_day)

      accept_confirm do
        click_button 'Delete'
      end

      expect(page).to have_content('Successfully deleted workout day')
    end
  end
end
