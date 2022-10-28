import '@hotwired/turbo-rails';
import setupTodaysWorkout from './todays_workout';
import setupBackButton from './back_button';

document.addEventListener('turbo:load', setupTodaysWorkout);
document.addEventListener('turbo:load', setupBackButton);
