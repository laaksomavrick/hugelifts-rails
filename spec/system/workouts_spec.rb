# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Workouts', type: :system do
  let!(:user) { create(:user) }
  let!(:workout) { create(:workout, user:) }

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

  describe 'edit page' do
    it 'shows a user\'s workout' do
      sign_in user
      visit edit_workout_path(workout.id)
      expect(find_field('Name').value).to eq workout.name
    end
  end
end
