# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Exercises' do
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
      expect(page).to have_content(Exercise.all.order(:name).first.name)
      expect(page).to have_current_path('/exercises')
    end

    describe 'pagination' do
      it 'can go to the next page' do
        sign_in user
        visit exercises_path

        click_link '2'

        next_page_exercise_name = Exercise.all.order(:name).all[Exercise::PAGINATION_SIZE + 1].name
        expect(page).to have_content(next_page_exercise_name)
      end

      it 'can go to the previous page' do
        sign_in user
        visit exercises_path

        click_link '2'
        click_link '1'

        first_page_exercise_name = Exercise.all.order(:name).first.name
        expect(page).to have_content(first_page_exercise_name)
      end
    end

    describe 'search' do
      it 'can search exercises' do
        sign_in user
        visit exercises_path

        search_term = 'barbell'
        barbell_exercises = Exercise.all.prefix_search_by_name(search_term)
        other_exercise = create(:exercise, name: 'foo')

        fill_in 'search', with: search_term
        click_button 'commit'

        barbell_exercises.each do |e|
          expect(page).to have_content(e.name)
        end

        expect(page).not_to have_content(other_exercise.name)
      end
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

    it 'can delete an exercise' do
      sign_in user

      visit edit_exercise_path(exercise.id)

      accept_confirm do
        click_button 'Delete'
      end

      expect(page).to have_content(I18n.t('exercises.destroy.success'))
    end
  end

  describe 'show page' do
    it 'shows an exercise' do
      sign_in user
      visit exercise_path(exercise.id)
      expect(page).to have_content(exercise.name)
    end

    it "shows an exercise's workout history" do
      workout_day = user.active_workout.workout_days.first
      workout_day_exercise = workout_day.exercises.first
      exercise = workout_day_exercise.exercise

      scheduled_workout = create(:scheduled_workout, workout_day:, user:, completed: true)
      create(:scheduled_workout_exercise, scheduled_workout:, workout_day_exercise:, sets: 4, reps: 10,
                                          result: [10, 9, 8, 7])

      sign_in user
      visit exercise_path(exercise.id)

      history_graph = find_by_id('exerciseHistoryChart')

      expect(history_graph).not_to be_nil
    end
  end
end
