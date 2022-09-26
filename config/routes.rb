# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root to: redirect('todays_workout')

  resources :workouts, only: %i[index edit update destroy new create] do
    resources :workout_days, path: 'days', only: %i[new create edit update destroy] do
      resources :workout_day_exercises, path: 'exercises', only: %i[new create edit update destroy]
    end
  end

  resources :todays_workout, only: [:index]
  resources :exercises, only: [:index]
end
