# frozen_string_literal: true

class TodaysWorkoutRepsController < ApplicationController
  def update
    id = params[:id].to_i
    params = update_todays_workout_rep_params
    ordinal = params[:ordinal].to_i
    rep_count = params[:rep_count].to_i

    # TODO: better way of doing this
    session[:todays_workout_state] ||= {}
    session[:todays_workout_state][id] ||= {}
    session[:todays_workout_state][id][ordinal] = rep_count

    respond_to do |format|
      format.json { render json: session[:todays_workout_state] }
    end
  end

  private

  def update_todays_workout_rep_params
    params.require(:todays_workout_rep).permit(:ordinal, :rep_count)
  end
end
