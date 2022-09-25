# frozen_string_literal: true

class WorkoutDayPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    user.id == record.workout.user_id
  end

  def destroy?
    user.id == record.workout.user_id
  end
end
