* workout
- id
- name
- is_active

* workout_day
- id
- workout_id

* workout_day_exercise
- id
- workout_day_id
- exercise_id
- metadata jsonb { sets, reps, weight }

=> daily workout (later)
- daily_workout_exercise
    - name bench press
    - sets 4
    - reps 10
    - weight 185
    - set 1 10/10
    - set 2 8/10
    - set 3 8/10
    - set 4  6/10