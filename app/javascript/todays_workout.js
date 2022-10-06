export default () => {
  const repButtons = document.querySelectorAll('[data-rep-button]');

  for (const repButton of repButtons) {
    repButton.addEventListener('click', (e) => {
      const node = e.target;

      const active = !!parseInt(node.getAttribute('data-rep-active'), 10);

      const id = node.getAttribute('data-exercise-id');
      const ordinal = node.getAttribute('data-rep-ordinal');
      const maxReps = node.getAttribute('data-max-reps');
      const repsDone = node.getAttribute('data-reps-done');

      console.log({ active, id, ordinal, maxReps, repsDone });

      if (active === false) {
        addActiveClassToRepButton(repButton);
      } else {
        setRepCount(repButton, { repsDone, maxReps });
      }

      // TODO: extract handler to its own function + DI via () => () => { ... } for tests

      // TODO: debounce an API call to store this in session
      // TODO: on todays workout index, need to set this data
      // => { exercise_id, ordinal} => active, max-reps, reps-done
    });
  }
};

const activeClass = 'bg-gray-600 text-white';
const inactiveClass = 'bg-white text-gray-600 border-2 border-gray-600';

const setRepCount = (repButton, { repsDone, maxReps }) => {
  const repCount = repsDone > 0 ? repsDone - 1 : maxReps;
  repButton.setAttribute('data-reps-done', repCount);
  repButton.innerText = repCount;
};

const addActiveClassToRepButton = (repButton) => {
  removeActiveClassFromRepButton(repButton);
  repButton.setAttribute('data-rep-active', '1');

  const classes = activeClass.split(' ');
  repButton.classList.add(...classes);
};

const removeActiveClassFromRepButton = (repButton) => {
  const classes = inactiveClass.split(' ');
  repButton.classList.remove(...classes);
};
