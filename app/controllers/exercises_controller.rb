# frozen_string_literal: true

class ExercisesController < ApplicationController
  def index
    @exercises = policy_scope(Exercise)
  end

  def edit
    exercise_id = params[:id].to_i
    @exercise = authorize Exercise.find_by(id: exercise_id)
  end

  def update
    # TODO
  end
end
