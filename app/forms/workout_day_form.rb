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

  def ordinal_disabled?
    @workout_day_id.nil?
  end

  def process(params = {})
    name = params[:name]
    ordinal = params[:ordinal].to_i

    if @workout_day_id
      begin
        WorkoutDay.transaction do
          workout_day.update!(name:)
          # Recompute ordinals
          # TODO: extract into mixin e.g. Ordinable or Sortable and put under test
          workout_days = WorkoutDay.where(workout:).where.not(id: @workout_day_id).order(ordinal: :asc).to_a
          workout_days.insert(ordinal, workout_day)
          workout_days.each_with_index do |wd, i|
            wd.ordinal = i
            wd.save!
          end
        end
        true
      rescue ActiveRecord::RecordInvalid
        false
      end
    else
      @workout_day = WorkoutDay.create(workout:, name:, ordinal:)
      @workout_day.save
    end
  end
end
