# frozen_string_literal: true

class ExercisesController < ApplicationController
  def index
    @exercises = current_user.exercises
  end
end
