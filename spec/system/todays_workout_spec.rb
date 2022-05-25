# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Today\'s Workout', type: :system do
  let!(:user) { create(:user) }

  describe 'index page' do
    it 'redirects non-authenticated users' do
      visit todays_workout_index_path
      expect(page).to have_content('Log in')
      expect(page).to have_current_path('/users/sign_in')
    end

    it 'shows a user\'s workout for today' do
      sign_in user
      visit todays_workout_index_path
      expect(page).to have_current_path('/todays_workout')
    end
  end
end
