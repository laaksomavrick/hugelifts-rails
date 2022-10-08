# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# TODO: refactor into seeder objects

user = User.create!(email: 'laakso.mavrick@gmail.com', password: 'Qweqwe1!')
exercises = user.exercises
bench_press = exercises.find { |x| x.name == 'Barbell Bench Press' }
overhead_press = exercises.find { |x| x.name == 'Barbell Overhead Press' }
barbell_row = exercises.find { |x| x.name == 'Barbell Row' }
chin_up = exercises.find { |x| x.name == 'Chinup' }
squat = exercises.find { |x| x.name == 'Back Squat' }
deadlift = exercises.find { |x| x.name == 'Deadlift' }

ppl = user.workouts.create!(name: 'PPL', active: true)
push_day = ppl.workout_days.create!(name: 'Push', ordinal: 0)
push_day.workout_day_exercises.create!(exercise: bench_press,
                                       meta: { 'sets' => 5, 'reps' => 5,
                                               'weight' => 135, unit: 'lb' })

push_day.workout_day_exercises.create!(exercise: overhead_press,
                                       meta: { 'sets' => 5, 'reps' => 5,
                                               'weight' => 135, unit: 'lb' })

pull_day = ppl.workout_days.create!(name: 'Pull', ordinal: 1)

pull_day.workout_day_exercises.create!(exercise: barbell_row,
                                       meta: { 'sets' => 5, 'reps' => 5,
                                               'weight' => 135, unit: 'lb' })

pull_day.workout_day_exercises.create!(exercise: chin_up,
                                       meta: { 'sets' => 5, 'reps' => 5,
                                               'weight' => 135, unit: 'lb' })

leg_day = ppl.workout_days.create!(name: 'Legs', ordinal: 2)

leg_day.workout_day_exercises.create!(exercise: squat,
                                      meta: { 'sets' => 5, 'reps' => 5,
                                              'weight' => 135, unit: 'lb' })

leg_day.workout_day_exercises.create!(exercise: deadlift,
                                      meta: { 'sets' => 5, 'reps' => 5,
                                              'weight' => 135, unit: 'lb' })

# Create another workout
FactoryBot.create(:workout, :with_days_and_exercises, user:)
FactoryBot.create(:workout, :with_days_and_exercises, user:)
