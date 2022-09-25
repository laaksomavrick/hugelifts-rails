# frozen_string_literal: true

class TodaysWorkoutController < ApplicationController
  def index
    policy_scope(nil, policy_scope_class: TodaysWorkoutPolicy::Scope)
  end
end
