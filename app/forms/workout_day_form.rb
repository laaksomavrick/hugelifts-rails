# frozen_string_literal: true

class WorkoutDayForm
  include ActiveModel::Model
  attr_reader :workout_id, :workout_day_id

  delegate :errors, to: :workout_day

  def initialize(workout_id:, workout_day_id: nil)
    @workout_id = workout_id
    @workout_day_id = workout_day_id
  end

  def workout
    @workout ||= Workout.find(@workout_id)
  end

  def workout_day
    @workout_day ||= if @workout_day_id.nil?
                       WorkoutDay.new
                     else
                       WorkoutDay.includes(workout_day_exercises: :exercise).find_by(id: @workout_day_id)
                     end
  end

  def ordinal
    if @workout_day_id.nil?
      @workout.workout_days.length
    else
      @workout_day.ordinal
    end
  end

  def ordinal_options
    max_ordinal = if @workout_day_id.nil?
                    @workout.workout_days.length
                  else
                    @workout.workout_days.length - 1
                  end
    [*0..max_ordinal]
  end

  def process(params = {})
    name = params[:name]

    if @workout_day_id
      workout_day.update(name:)
    else
      @workout_day = WorkoutDay.create(workout:, name:)
      @workout_day.save
    end
  end
end
