const activeClass =
  'bg-yellow-400 hover:bg-yellow-600 text-gray-50 font-bold py-2 px-4 rounded cursor-pointer';
const inactiveClass =
  'bg-white hover:bg-gray-100 border border-gray-300 font-bold py-2 px-4 rounded cursor-pointer';

const activeText = 'Skipped';
const inactiveText = 'Skip';

const getCheckBox = () =>
  document.querySelector('[data-skip-todays-workout-check-box]');
const getSkipButton = () =>
  document.querySelector('[data-skip-todays-workout-button]');

const getCheckBoxValue = () => {
  const checkBox = getCheckBox();
  return checkBox.checked;
};

const setCheckBoxValue = (checked = false) => {
  const checkBox = getCheckBox();
  checkBox.checked = checked;
};

const setSkipButtonActive = () => {
  const skipButton = getSkipButton();
  const inactiveClasses = inactiveClass.split(' ');
  const activeClasses = activeClass.split(' ');
  skipButton.classList.remove(...inactiveClasses);
  skipButton.classList.add(...activeClasses);
  skipButton.innerHTML = activeText;
};

const setSkipButtonInactive = () => {
  const skipButton = getSkipButton();
  const inactiveClasses = inactiveClass.split(' ');
  const activeClasses = activeClass.split(' ');
  skipButton.classList.remove(...activeClasses);
  skipButton.classList.add(...inactiveClasses);
  skipButton.innerHTML = inactiveText;
};

const onSkipButtonClick = () => {
  const checked = getCheckBoxValue();

  if (checked) {
    setCheckBoxValue(false);
    setSkipButtonInactive();
  } else {
    setCheckBoxValue(true);
    setSkipButtonActive();
  }
};

export default onSkipButtonClick;
