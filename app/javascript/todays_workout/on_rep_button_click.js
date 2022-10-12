import {
  addActiveClassToRepButton,
  checkCompleteButton,
  getRepButtonAttributes,
} from './common';

const onRepButtonClick =
  ({ repButtons, completeButton, totalSets }) =>
  (e) => {
    const node = e.target;

    const { active, id, ordinal, maxReps, repsDone } =
      getRepButtonAttributes(node);

    if (active === false) {
      addActiveClassToRepButton(node);
      cacheRepCount({ id, ordinal, maxReps });
    } else {
      const repCount = getRepCount({ repsDone, maxReps });
      setRepCount(node, { id, ordinal, repCount });
      cacheRepCount({ id, ordinal, repCount });
    }

    checkCompleteButton(completeButton, { totalSets });

    // TODO: debounce an API call to store this in session
    // TODO: on todays workout index, need to set this data
    // => { exercise_id, ordinal} => active, max-reps, reps-done
  };

const cacheRepCount = async ({ id, ordinal, repCount }) => {
  console.log({ id, ordinal, repCount });
  const csrfToken = document.getElementsByName('csrf-token')[0].content;
  const res = await fetch(`/todays_workout_reps/${id}`, {
    method: 'PATCH',
    headers: {
      'X-CSRF-Token': csrfToken,
      'Content-Type': 'application/json',
      Accept: 'application/json',
    },
    body: JSON.stringify({
      ordinal,
      rep_count: repCount,
    }),
  });
  const json = await res.json();
  console.log(json);
};

const getRepCount = ({ repsDone, maxReps }) => {
  return repsDone > 0 ? repsDone - 1 : maxReps;
};

const setRepCount = (repButton, { id, ordinal, repCount }) => {
  const resultInput = document.getElementById(
    `exercise_${id}_${ordinal}_result`,
  );

  repButton.setAttribute('data-reps-done', repCount);
  repButton.innerText = repCount;
  resultInput.value = repCount;
};

export default onRepButtonClick;
