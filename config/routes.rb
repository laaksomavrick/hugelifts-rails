# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('todays_workout')

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :workouts, only: %i[index edit update destroy new create] do
    resources :workout_days, path: 'days', only: %i[new create edit update destroy] do
      resources :workout_day_exercises, path: 'exercises', only: %i[new create edit update destroy]
    end
  end

  resources :todays_workout, only: %i[index update]
  resources :todays_workout_reps, only: %i[update]
  resources :exercises, only: %i[index edit update new create destroy]
end
