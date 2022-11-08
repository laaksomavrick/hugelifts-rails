export default () => {
  const exerciseHistory = document.querySelector('[data-exercise-history]');

  if (exerciseHistory == null) {
    return;
  }

  const entries = JSON.parse(
    exerciseHistory.getAttribute('data-exercise-history-entries') || null,
  );

  if (entries == null) {
    console.error(
      'data-exercise-history-entries is required for exercise_history',
    );
    return;
  }

  console.log(entries);
};
