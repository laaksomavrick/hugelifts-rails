# frozen_string_literal: true

class WorkoutDayExercisePolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    user.id == record.workout_day.workout.user_id
  end

  def destroy?
    user.id == record.workout_day.workout.user_id
  end
end
