# frozen_string_literal: true

class ExercisePolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope.where(user_id: user.id)
    end

    private

    attr_reader :user, :scope
  end

  def update?
    user.id == record.user_id
  end

  def create?
    true
  end

  def destroy?
    true
  end
end
