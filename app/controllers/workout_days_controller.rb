# frozen_string_literal: true

# TODO: authorization logic (e.g. policy on this resource) with pundit

class WorkoutDaysController < ApplicationController
  def new
    workout_id = params[:workout_id].to_i
    @form = WorkoutDayForm.new(workout_id:)
  end

  def create
    workout_id = params[:workout_id].to_i

    @form = WorkoutDayForm.new(workout_id:)
    saved = @form.process(params[:workout_day_form])

    if saved == false
      render 'new', status: :unprocessable_entity
    else
      flash[:notice] = 'Successfully saved'
      redirect_to(edit_workout_path(@form.workout))
    end
  end

  def edit
    workout_day_id = params[:id].to_i
    workout_id = params[:workout_id].to_i
    @form = WorkoutDayForm.new(workout_id:, workout_day_id:)
  end

  def update
    workout_id = params[:workout_id].to_i
    workout_day_id = params[:id].to_i

    @form = WorkoutDayForm.new(workout_id:, workout_day_id:)
    saved = @form.process(params[:workout_day_form])

    if saved == false
      render 'edit', status: :unprocessable_entity
    else
      flash[:notice] = 'Successfully saved'
      redirect_to(edit_workout_workout_day_path)
    end
  end

  def destroy
    params = destroy_workout_day_params
    workout_id = params[:workout_id].to_i
    workout_day_id = params[:id].to_i

    workout_day = WorkoutDay.find_by(id: workout_day_id)
    workout_day.destroy

    flash[:notice] = 'Successfully deleted workout day'

    redirect_to(edit_workout_path(workout_id))
  end

  private

  def destroy_workout_day_params
    params.permit(:id, :workout_id)
  end

  def create_workout_day_params
    params.require(:workout_day).permit(:name)
  end

  def update_workout_day_params
    params.require(:workout_day).permit(:name)
  end
end
