# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Today\'s Workout', type: :system do
  let!(:user) { create(:user) }
  let!(:workout) { create(:workout, :with_days_and_exercises, user:, active: true) }

  describe 'update' do
    it 'can complete a scheduled workout' do
      sign_in user
      visit todays_workout_index_path

      page.all(:css, 'div[data-rep-button]').each(&:click)

      complete_button = find_button 'Complete'
      complete_button.click

      expect(page).to have_content(I18n.t('todays_workout.update.success'))
      expect(page).to have_content(workout.workout_days.second.name)
    end
  end

  describe 'index page' do
    it 'redirects non-authenticated users' do
      visit todays_workout_index_path
      expect(page).to have_content('Log in')
      expect(page).to have_current_path('/users/sign_in')
    end

    it 'shows a scheduled workout when none exists' do
      first_workout_day = workout.workout_days.first
      sign_in user
      visit todays_workout_index_path

      expect(page).to have_content(first_workout_day.name)
      first_workout_day.exercises.each do |exercise|
        expect(page).to have_content(exercise.name)
      end
    end

    it 'shows the new scheduled workout when active workout changes' do
      sign_in user

      visit todays_workout_index_path
      expect(page).to have_content(workout.workout_days.first.name)

      workout.active = false
      workout.save!

      new_workout = create(:workout, :with_days_and_exercises, user:, active: true)
      new_workout.save!

      visit todays_workout_index_path

      first_workout_day = new_workout.workout_days.first
      expect(page).to have_content(first_workout_day.name)
      first_workout_day.exercises.each do |exercise|
        expect(page).to have_content(exercise.name)
      end
    end

    it 'shows a scheduled workout when scheduled workout is incomplete' do
      workout_day = workout.workout_days.first
      scheduled_workout = create(:scheduled_workout, :with_exercises, user:, workout_day:)

      sign_in user
      visit todays_workout_index_path

      workout_day = scheduled_workout.workout_day

      expect(page).to have_content(workout_day.name)
      workout_day.exercises.each do |exercise|
        expect(page).to have_content(exercise.name)
      end
    end

    it 'shows a scheduled workout when last scheduled workout was completed' do
      first_workout_day = workout.workout_days.first
      second_workout_day = workout.workout_days.second
      sign_in user
      visit todays_workout_index_path

      scheduled_workout = ScheduledWorkout.where(user:, workout_day: first_workout_day).first
      scheduled_workout.completed = true
      scheduled_workout.save!

      visit todays_workout_index_path

      expect(page).to have_content(second_workout_day.name)
      second_workout_day.exercises.each do |exercise|
        expect(page).to have_content(exercise.name)
      end
    end

    it 'shows missing message when no workout exists' do
      sign_in user
      workout.destroy!
      visit todays_workout_index_path
      expect(page).to have_content(I18n.t('todays_workout.missing'))
    end

    it 'shows previous workout progress on reload' do
      workout_day = workout.workout_days.first
      sign_in user
      visit todays_workout_index_path

      rep_button = page.all(:css, 'div[data-rep-button]').first
      rep_button_reps_done = rep_button['data-reps-done'].to_i
      rep_button.click
      rep_button.click

      # TODO: better solution for ajax (e.g. waiting until an element is visible)
      sleep 1

      visit todays_workout_index_path

      rep_button = page.all(:css, 'div[data-rep-button]').first
      expect(page).to have_content(workout_day.name)
      expect(rep_button).to have_content((rep_button_reps_done - 1).to_s)
    end
  end
end
