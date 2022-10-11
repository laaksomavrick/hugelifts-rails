# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Exercises', type: :system do
  let!(:user) { create(:user) }
  let!(:exercise) { create(:exercise, user:) }

  describe 'index page' do
    it 'redirects non-authenticated users' do
      visit exercises_path
      expect(page).to have_content('Log in')
      expect(page).to have_current_path('/users/sign_in')
    end

    it 'shows a user\'s exercises' do
      sign_in user
      visit exercises_path
      expect(page).to have_content(Exercise.default_exercise_names.sample)
      expect(page).to have_current_path('/exercises')
    end
  end

  describe 'new page' do
    it 'shows an error when name is empty' do
      sign_in user
      visit new_exercise_path

      fill_in 'Name', with: ''

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page).to have_content("Name can't be blank")
    end

    it 'can create an exercise' do
      name = 'XXL Lift'
      sign_in user

      visit new_exercise_path

      fill_in 'Name', with: name

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page).to have_content(I18n.t('exercises.create.success'))
      expect(find_field('Name').value).to eq name
    end
  end

  describe 'edit page' do
    it 'shows an exercise' do
      sign_in user
      visit edit_exercise_path(exercise.id)
      expect(find_field('Name').value).to eq exercise.name
    end

    it 'can update an exercise' do
      sign_in user

      visit edit_exercise_path(exercise.id)

      fill_in 'Name', with: 'Foo'

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page).to have_content(I18n.t('exercises.update.success'))
      expect(find_field('Name').value).to eq 'Foo'
    end

    it 'shows an error when name is empty' do
      sign_in user
      visit edit_exercise_path(exercise.id)

      fill_in 'Name', with: ''

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page).to have_content("Name can't be blank")
    end
  end
end
