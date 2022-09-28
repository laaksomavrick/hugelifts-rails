- today's workout view + functionality
  - For the active workout
  1) Find the appropriate workout_day_scheduled_instance
     1) If no workout_day_scheduled_instance, ordinal 0 for the workout's workout_days
     3) If workout_day_scheduled_instance that is not complete, present that
     2) If workout_day_scheduled_instance are all complete, use the next ordinal in the workout's workout_days cycle 
  2) Create a new workout_day_instance for the workout_day if required

=> ordinals on workout_day
=> workout_day_scheduled_instance model 
    { id, workout_id, completed, jsonb{ exercises: [...]} }
        { exercise_id: 1, sets: 4, reps: 10, result: [10, 10, 8, 6] }
        { exercise_id: 2, sets: 4, reps: 10, result: [10, 10, 8, 6] }

- exercise details view



ordinal sorting

[0, 1, 2]

1) [0,0*,2] => [0, 1*, 2]
2) [0, 2*, 2] => [0, 1, 2*]

PORO: OrdinalSorter.sort(collection, key:?)
-> do TDD