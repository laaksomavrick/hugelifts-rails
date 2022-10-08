export default () => {
  const repButtons = document.querySelectorAll('[data-rep-button]');
  const completeButton = document.querySelector('[data-complete-button]');

  for (const repButton of repButtons) {
    repButton.addEventListener('click', (e) => {
      const totalSets = repButtons.length;
      const node = e.target;

      const active = !!parseInt(node.getAttribute('data-rep-active'), 10);

      const id = node.getAttribute('data-exercise-id');
      const ordinal = node.getAttribute('data-rep-ordinal');
      const maxReps = node.getAttribute('data-max-reps');
      const repsDone = node.getAttribute('data-reps-done');

      if (active === false) {
        addActiveClassToRepButton(repButton);
      } else {
        setRepCount(repButton, { id, ordinal, repsDone, maxReps });
      }

      checkCompleteButton(completeButton, { totalSets });

      // TODO: extract handler to its own function + DI via (repButtons, completeButton) => () => { ... } for tests
      // - on click, when not active, active is toggled
      // - on click, when active, rep count is decreased
      // - on click, when rep count is 0, resets to maxReps
      // - when all reps completed, completed is no loner disabled

      // TODO: debounce an API call to store this in session
      // TODO: on todays workout index, need to set this data
      // => { exercise_id, ordinal} => active, max-reps, reps-done
    });
  }
};

const activeClass = 'bg-gray-600 text-white';
const inactiveClass = 'bg-white text-gray-600 border-2 border-gray-600';
const buttonDisabledClass = 'disabled:bg-green-300 disabled:cursor-not-allowed';

const setRepCount = (repButton, { id, ordinal, repsDone, maxReps }) => {
  const resultInput = document.getElementById(
    `exercise_${id}_${ordinal}_result`,
  );
  const repCount = repsDone > 0 ? repsDone - 1 : maxReps;

  repButton.setAttribute('data-reps-done', repCount);
  repButton.innerText = repCount;
  resultInput.value = repCount;
};

const addActiveClassToRepButton = (repButton) => {
  const inactiveClasses = inactiveClass.split(' ');
  const activeClasses = activeClass.split(' ');

  repButton.classList.remove(...inactiveClasses);
  repButton.classList.add(...activeClasses);

  repButton.setAttribute('data-rep-active', '1');
};

const checkCompleteButton = (completeButton, { totalSets }) => {
  const activeRepButtons = document.querySelectorAll('[data-rep-active="1"]');
  const isComplete = activeRepButtons.length === totalSets;

  if (isComplete === false) {
    return;
  }

  const disabledClassList = buttonDisabledClass.split(' ');

  completeButton.classList.remove(...disabledClassList);
  completeButton.removeAttribute('disabled');
};
