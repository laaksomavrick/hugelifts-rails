import { addActiveClassToRepButton, getRepButtonAttributes } from './common';

const setRepButtonState = (repButton) => {
  const { active } = getRepButtonAttributes(repButton);

  if (active === false) {
    return;
  }

  addActiveClassToRepButton(repButton);
};

export default setRepButtonState;
