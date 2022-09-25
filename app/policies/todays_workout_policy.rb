# frozen_string_literal: true

class TodaysWorkoutPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      true
    end

    private

    attr_reader :user, :scope
  end
end
