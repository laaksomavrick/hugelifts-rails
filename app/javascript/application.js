import '@hotwired/turbo-rails';
import registerServiceWorker from './register_service_worker';
import setupTodaysWorkout from './todays_workout';
import setupBackButton from './back_button';
import setupSetTimerButton from './set_timer_button';
import setupExerciseHistory from './exercise_history';

document.addEventListener('turbo:load', setupTodaysWorkout);
document.addEventListener('turbo:load', setupBackButton);
document.addEventListener('turbo:load', setupSetTimerButton);
document.addEventListener('turbo:load', setupExerciseHistory);

registerServiceWorker();
