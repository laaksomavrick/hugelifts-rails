# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # root to: 'todays_workout#index'
  root to: redirect('todays_workout')


  resources :workouts, only: [:index]
  resources :todays_workout, only: [:index]
  resources :exercises, only: [:index]
end
