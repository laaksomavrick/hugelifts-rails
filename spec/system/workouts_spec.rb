# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Workouts' do
  let!(:user) { create(:user) }
  let!(:workout) { user.workouts.where(active: true).first }

  describe 'index page' do
    it 'redirects non-authenticated users' do
      visit workouts_path
      expect(page).to have_content('Log in')
      expect(page).to have_current_path('/users/sign_in')
    end

    it 'shows a user\'s workouts' do
      sign_in user
      visit workouts_path
      expect(page).to have_current_path('/workouts')
      expect(page).to have_content(workout.name)
    end
  end

  describe 'new page' do
    it 'shows an error when name is empty' do
      sign_in user
      visit new_workout_path

      fill_in 'Name', with: ''

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page).to have_content("Name can't be blank")
    end

    it 'can create a workout' do
      name = 'FooBarBaz'
      sign_in user

      visit new_workout_path

      fill_in 'Name', with: name

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page).to have_content(I18n.t('workouts.create.success'))
      expect(find_field('Name').value).to eq name
    end
  end

  describe 'edit page' do
    it 'shows a user\'s workout' do
      sign_in user
      visit edit_workout_path(workout.id)
      expect(find_field('Name').value).to eq workout.name
    end

    it 'shows an error when name is empty' do
      sign_in user
      visit edit_workout_path(workout.id)

      fill_in 'Name', with: ''

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page).to have_content("Name can't be blank")
    end

    it 'is still active when validation error occurs' do
      sign_in user
      visit edit_workout_path(workout.id)

      fill_in 'Name', with: ''

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page.find('input#workout_active')).to be_checked
    end

    it 'can update a workout day' do
      sign_in user

      visit edit_workout_path(workout.id)

      fill_in 'Name', with: 'Upper/Lower Split'

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page).to have_content(I18n.t('workouts.update.success'))
      expect(find_field('Name').value).to eq 'Upper/Lower Split'
    end

    it 'cannot delete an active workout' do
      sign_in user

      visit edit_workout_path(workout.id)

      accept_confirm do
        click_button 'Delete'
      end

      expect(page).to have_content(I18n.t('workouts.destroy.cannot_delete_workout'))
    end

    it 'can delete an inactive workout' do
      inactive_workout = create(:workout, user:, active: false)
      sign_in user

      visit edit_workout_path(inactive_workout.id)

      accept_confirm do
        click_button 'Delete'
      end

      expect(page).to have_content(I18n.t('workouts.destroy.success'))
    end
  end
end
