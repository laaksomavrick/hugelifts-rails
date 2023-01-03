import onRepButtonClick from './on_rep_button_click';
import setRepButtonState from './set_rep_button_state';
import onSkipButtonClick from './on_skip_button_click';
import { checkCompleteButton } from './common';

export default () => {
  const repButtons = document.querySelectorAll('[data-rep-button]');
  const completeButton = document.querySelector('[data-complete-button]');
  const skipButton = document.querySelector(
    '[data-skip-todays-workout-button]',
  );
  const totalSets = repButtons.length;

  for (const repButton of repButtons) {
    repButton.addEventListener(
      'click',
      onRepButtonClick({ completeButton, totalSets }),
    );

    setRepButtonState(repButton);
  }

  if (skipButton) {
    skipButton.addEventListener('click', onSkipButtonClick);
  }

  checkCompleteButton(completeButton, { totalSets });
};
