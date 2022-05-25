# frozen_string_literal: true

class WorkoutDaysController < ApplicationController
  def show
    workout_day_id = params[:id]
    @workout_day = WorkoutDay.find_by(id: workout_day_id)
  end
end
