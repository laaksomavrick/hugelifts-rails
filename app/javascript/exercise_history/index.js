import { Chart, registerables } from 'chart.js';
import { format } from 'date-fns';
import { min, max } from 'lodash';
Chart.register(...registerables);

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

  if (Array.isArray(entries) === false || entries.length === 0) {
    return;
  }

  const oneRepMaxes = entries.map((x) => x.one_rep_max);

  const ctx = document.getElementById('exerciseHistoryChart').getContext('2d');

  const labels = entries.map((x) => format(new Date(x.date), 'MMM do'));
  const datasets = [
    {
      label: 'One rep max (lbs)',
      data: oneRepMaxes,
      fill: false,
      borderColor: 'rgb(75, 192, 192)',
      tension: 0.1,
    },
  ];

  const minY = min(oneRepMaxes) - 25;
  const maxY = max(oneRepMaxes) + 25;

  const data = {
    labels,
    datasets,
  };

  new Chart(ctx, {
    type: 'line',
    data: data,
    options: {
      elements: {
        point: {
          radius: 6,
        },
      },
      scales: {
        y: {
          min: minY,
          max: maxY,
          ticks: {
            precision: 0,
            stepSize: 5,
          },
        },
      },
      plugins: {
        legend: false,
      },
    },
  });
};
