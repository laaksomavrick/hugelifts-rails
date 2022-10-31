import onSetTimerClick from './on_set_timer_click';

export default () => {
  const setTimerButtons = document.querySelectorAll('[data-set-timer-button]');

  for (const setTimerButton of setTimerButtons) {
    setTimerButton.addEventListener('click', onSetTimerClick);
  }
};
