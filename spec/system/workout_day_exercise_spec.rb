# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Workout Day Exercises', type: :system do
  let!(:user) { create(:user) }
  let!(:workout) { create(:workout, user:) }
  let!(:workout_day) { create(:workout_day, workout:) }
  let!(:workout_day_exercise) { create(:workout_day_exercise, workout_day:) }

  describe 'create page' do
    it 'redirects non-authenticated users' do
      visit new_workout_workout_day_workout_day_exercise_path(workout.id, workout_day.id)
      expect(page).to have_content('Log in')
      expect(page).to have_current_path('/users/sign_in')
    end

    it 'populates the create workout day exercise form' do
      sign_in user
      visit new_workout_workout_day_workout_day_exercise_path(workout.id, workout_day.id)

      workout_hidden_input = find('input#workout_day_exercise_form_workout', visible: false)
      workout_day_hidden_input = find('input#workout_day_exercise_form_workout_day', visible: false)
      unit_hidden_input = find('input#workout_day_exercise_form_unit', visible: false)

      weight_input = find('input#workout_day_exercise_form_weight')

      expect(workout_hidden_input.value.to_i).to eq workout.id
      expect(workout_day_hidden_input.value.to_i).to eq workout_day.id
      expect(unit_hidden_input.value).to eq 'lb'
      expect(weight_input.value.to_i).to eq 135

      expect(page).to have_select('workout_day_exercise_form_sets', selected: '4')
      expect(page).to have_select('workout_day_exercise_form_reps', selected: '10')
    end

    it 'can create a workout day exercise' do
      sign_in user
      visit new_workout_workout_day_workout_day_exercise_path(workout.id, workout_day.id)

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page).to have_current_path("/workouts/#{workout.id}/days/#{workout_day.id}")
      expect(page).to have_content(workout_day_exercise.exercise.name)
    end
  end

  describe 'edit page' do
    it 'redirects non-authenticated users' do
      visit edit_workout_workout_day_workout_day_exercise_path(workout.id, workout_day.id, workout_day_exercise.id)
      expect(page).to have_content('Log in')
      expect(page).to have_current_path('/users/sign_in')
    end

    it 'populates the edit workout day exercise form' do
      sign_in user
      visit edit_workout_workout_day_workout_day_exercise_path(workout.id, workout_day.id, workout_day_exercise.id)

      workout_hidden_input = find('input#workout_day_exercise_form_workout', visible: false)
      workout_day_hidden_input = find('input#workout_day_exercise_form_workout_day', visible: false)
      unit_hidden_input = find('input#workout_day_exercise_form_unit', visible: false)

      weight_input = find('input#workout_day_exercise_form_weight')

      expect(workout_hidden_input.value.to_i).to eq workout.id
      expect(workout_day_hidden_input.value.to_i).to eq workout_day.id
      expect(unit_hidden_input.value).to eq workout_day_exercise.unit
      expect(weight_input.value.to_i).to eq workout_day_exercise.weight

      expect(page).to have_select('workout_day_exercise_form_sets', selected: workout_day_exercise.sets.to_s)
      expect(page).to have_select('workout_day_exercise_form_reps', selected: workout_day_exercise.reps.to_s)
    end

    it 'can update a workout day exercise' do
      sign_in user

      visit edit_workout_workout_day_workout_day_exercise_path(workout.id, workout_day.id, workout_day_exercise.id)

      select 'Barbell Bench Press', from: 'workout_day_exercise_form_exercise'
      select '5', from: 'workout_day_exercise_form_sets'
      select '8', from: 'workout_day_exercise_form_reps'
      fill_in 'Weight', with: 225

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page).to have_current_path("/workouts/#{workout.id}/days/#{workout_day.id}")
      expect(page).to have_content('Barbell Bench Press')
      expect(page).to have_content('5')
      expect(page).to have_content('8')
      expect(page).to have_content('225')
    end
  end
end
