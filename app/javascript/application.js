import '@hotwired/turbo-rails';
import setupTodaysWorkout from './todays_workout';

document.addEventListener('turbo:load', setupTodaysWorkout);
