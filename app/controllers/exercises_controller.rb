# frozen_string_literal: true

class ExercisesController < ApplicationController
  def index
    @exercises = policy_scope(Exercise)
  end
end
