# frozen_string_literal: true

# TODO: authorization
class ExercisesController < ApplicationController
  def index
    @exercises = current_user.exercises
  end
end
