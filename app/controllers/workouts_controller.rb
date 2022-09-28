# frozen_string_literal: true

class WorkoutsController < ApplicationController
  def index
    @workouts = policy_scope(Workout).order(active: :desc)
  end

  def new
    @workout = authorize Workout.new
  end

  def create
    params = create_workout_params
    name = params[:name]
    active = params[:active].to_i == 1

    @workout = authorize Workout.new
    @workout.name = name
    @workout.active = active
    @workout.user_id = current_user.id

    if active
      @workout.save_with_active!(user_id: current_user.id)
    else
      @workout.save!
    end

    flash[:notice] = t('workouts.create.success')
    redirect_to(edit_workout_path(@workout.id))
  rescue ActiveRecord::RecordInvalid
    render 'new', status: :unprocessable_entity
  end

  def edit
    workout_id = params[:id].to_i
    @workout = authorize Workout
               .includes(:workout_days)
               .find_by(id: workout_id)
  end

  def update
    params = update_workout_params
    workout_id = params[:workout].to_i
    name = params[:name]
    active = params[:active].to_i == 1

    @workout = authorize Workout.find_by(id: workout_id)

    @workout.name = name
    @workout.active = active

    @workout.save_with_active!(user_id: current_user.id)

    flash[:notice] = t('workouts.update.success')
    redirect_to(edit_workout_path(@workout.id))
  rescue ActiveRecord::RecordInvalid
    render 'edit', status: :unprocessable_entity
  end

  def destroy
    workout_id = params[:id].to_i

    workout = authorize Workout.find_by(id: workout_id)

    if workout.active?
      flash[:alert] = t('workouts.destroy.cannot_delete_workout')
      redirect_to(edit_workout_path(workout_id))
    else
      workout.destroy
      flash[:notice] = t('workouts.destroy.success')
      redirect_to(workouts_path)
    end
  end

  private

  def update_workout_params
    params.require(:workout).permit(:workout, :name, :active)
  end

  def create_workout_params
    params.require(:workout).permit(:name, :active)
  end
end
