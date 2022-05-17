# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Exercises', type: :system do
  let!(:user) { create(:user) }

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
end
