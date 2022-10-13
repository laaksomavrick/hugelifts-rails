import {
  addActiveClassToRepButton,
  checkCompleteButton,
  getRepButtonAttributes,
} from './common';
import { patch } from '../api';
import { get } from 'lodash';

const onRepButtonClick =
  ({ completeButton, totalSets }) =>
  async (e) => {
    const node = e.target;

    const { active, id, ordinal, maxReps, repsDone } =
      getRepButtonAttributes(node);

    if (active === false) {
      addActiveClassToRepButton(node);
      await cacheRepCount({ id, ordinal, repCount: maxReps });
    } else {
      const repCount = getRepCount({ repsDone, maxReps });
      setRepCount(node, { id, ordinal, repCount });
      await cacheRepCount({ id, ordinal, repCount });
    }

    checkCompleteButton(completeButton, { totalSets });
  };

const cacheRepCount = async ({ id, ordinal, repCount }) => {
  let csrfToken = document.getElementById('csrf-token');
  console.log(csrfToken);
  csrfToken = get(csrfToken, '[0].content', null);
  const url = `/todays_workout_reps/${id}`;
  await patch({
    url,
    csrfToken,
    body: {
      ordinal,
      rep_count: repCount,
    },
  });
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
