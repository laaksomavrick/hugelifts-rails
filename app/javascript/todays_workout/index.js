import { onRepButtonClick } from './todays_workout';

export default () => {
  const repButtons = document.querySelectorAll('[data-rep-button]');
  const completeButton = document.querySelector('[data-complete-button]');

  for (const repButton of repButtons) {
    repButton.addEventListener(
      'click',
      onRepButtonClick({ repButtons, completeButton }),
    );
  }
};
