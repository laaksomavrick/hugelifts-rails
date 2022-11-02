import timerTickWorkerFactory from '../timer_tick_worker';

const onSetTimerClick = async (e) => {
  e.preventDefault();
  const tickWorker = timerTickWorkerFactory();
  const button = e.target;

  if (isActive(button)) {
    location.reload();
    return;
  }

  await requestNotificationPermissions();

  setButtonText({ button, ticks: 120 });
  setButtonActive(button);

  tickWorker.onmessage = async ({ data: ticks }) => {
    const expired = ticks <= 0;

    if (expired) {
      await handleTimerOver();
      return;
    }

    setButtonText({ button, ticks });
  };
};

const requestNotificationPermissions = async () => {
  try {
    await Notification.requestPermission();
  } catch (e) {
    console.error(e);
  }
};

const handleTimerOver = async () => {
  const permission = await Notification.requestPermission();

  if (permission !== 'granted') {
    return;
  }
  const registration = await navigator.serviceWorker.getRegistration();

  if (registration == null) {
    return;
  }

  await registration.showNotification('Rest timer ended', {
    vibrate: [200, 100, 200, 100],
    tag: 'rest-timer-notification',
  });

  location.reload();
};

const setButtonText = ({ button, ticks }) => {
  const time = secondsToTime(ticks);
  button.innerText = time;
};

const setButtonActive = (button) => {
  button.setAttribute('data-set-timer-active', '1');
};

const isActive = (button) => {
  return !!parseInt(button.getAttribute('data-set-timer-active'), 10);
};

const secondsToTime = (e) => {
  const m = Math.floor((e % 3600) / 60)
      .toString()
      .padStart(2, '0'),
    s = Math.floor(e % 60)
      .toString()
      .padStart(2, '0');
  return `${m}:${s}`;
};

export default onSetTimerClick;
