# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.create!(email: 'laakso.mavrick@gmail.com', password: 'Qweqwe1!')

ppl = user.workouts.create!(name: 'PPL', active: true)

ppl.workout_days.create!(name: 'Push', ordinal: 0)
ppl.workout_days.create!(name: 'Pull', ordinal: 1)
ppl.workout_days.create!(name: 'Legs', ordinal: 2)
