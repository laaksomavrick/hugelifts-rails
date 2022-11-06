# frozen_string_literal: true

class ExercisesController < ApplicationController
  def index
    page = params[:page]
    @exercises = policy_scope(Exercise).all.page(page)
  end

  def new
    @exercise = authorize Exercise.new
  end

  def create
    params = create_exercise_params
    name = params[:name]

    @exercise = authorize Exercise.new
    @exercise.user = current_user
    @exercise.name = name
    @exercise.save!

    flash[:notice] = t('exercises.create.success')
    redirect_to edit_exercise_path(@exercise.id)
  rescue ActiveRecord::RecordInvalid
    render 'new', status: :unprocessable_entity
  end

  def edit
    exercise_id = params[:id].to_i
    @exercise = authorize Exercise.find_by(id: exercise_id)
  end

  def update
    params = update_exercise_params
    exercise_id = params[:exercise]
    name = params[:name]

    @exercise = authorize Exercise.find_by(id: exercise_id)

    @exercise.name = name
    @exercise.save!

    flash[:notice] = t('exercises.update.success')
    redirect_to edit_exercise_path(@exercise.id)
  rescue ActiveRecord::RecordInvalid
    render 'edit', status: :unprocessable_entity
  end

  def destroy
    exercise_id = params[:id].to_i

    @exercise = authorize Exercise.find_by(id: exercise_id)
    @exercise.destroy

    flash[:notice] = t('exercises.destroy.success')
    redirect_to(exercises_path)
  end

  private

  def create_exercise_params
    params.require(:exercise).permit(:name)
  end

  def update_exercise_params
    params.require(:exercise).permit(:name, :exercise)
  end
end
