const ONE_SECOND = 1000;
const TWO_MINUTES = 120;

const onSetTimerClick = async (e) => {
  e.preventDefault();
  const button = e.target;

  if (isActive(button)) {
    location.reload();
    return;
  }

  await Notification.requestPermission();

  let ticks = TWO_MINUTES;

  setButtonText({ button, ticks });
  setButtonActive(button);

  setInterval(() => {
    ticks = ticks - 1;
    const expired = ticks === 0;
    if (expired) {
      handleTimerOver();
      return;
    }

    setButtonText({ button, ticks });
  }, ONE_SECOND);
};

const handleTimerOver = () => {
  new Notification('Timer ended!');
  alert('Timer ended!');
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
