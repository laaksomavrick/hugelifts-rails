const activeClass = 'bg-gray-600 text-white';
const inactiveClass = 'bg-white text-gray-600 border-2 border-gray-600';
const buttonDisabledClass = 'disabled:bg-green-300 disabled:cursor-not-allowed';

export const getRepButtonAttributes = (repButton) => {
  const active = !!parseInt(repButton.getAttribute('data-rep-active'), 10);
  const id = repButton.getAttribute('data-exercise-id');
  const ordinal = repButton.getAttribute('data-rep-ordinal');
  const maxReps = repButton.getAttribute('data-max-reps');
  const repsDone = repButton.getAttribute('data-reps-done');

  return {
    active,
    id,
    ordinal,
    maxReps,
    repsDone,
  };
};
export const addActiveClassToRepButton = (repButton) => {
  const inactiveClasses = inactiveClass.split(' ');
  const activeClasses = activeClass.split(' ');

  repButton.classList.remove(...inactiveClasses);
  repButton.classList.add(...activeClasses);

  repButton.setAttribute('data-rep-active', '1');
};

export const checkCompleteButton = (completeButton, { totalSets }) => {
  const activeRepButtons = document.querySelectorAll('[data-rep-active="1"]');
  const isComplete = activeRepButtons.length === totalSets;

  if (isComplete === false) {
    return;
  }

  const disabledClassList = buttonDisabledClass.split(' ');

  completeButton.classList.remove(...disabledClassList);
  completeButton.removeAttribute('disabled');
};
