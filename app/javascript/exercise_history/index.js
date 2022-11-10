import { Chart, registerables } from 'chart.js';
import { format } from 'date-fns';
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

  const ctx = document.getElementById('exerciseHistoryChart').getContext('2d');

  const labels = entries.map((x) => format(new Date(x.date), 'MMM do'));
  const datasets = [
    {
      label: 'One rep max (lbs)',
      data: entries.map((x) => x.one_rep_max),
      fill: false,
      borderColor: 'rgb(75, 192, 192)',
      tension: 0.1,
    },
  ];

  const data = {
    labels,
    datasets,
  };

  new Chart(ctx, {
    type: 'line',
    data: data,
    options: {
      scales: {
        y: {
          beginAtZero: true,
        },
      },
      plugins: {
        legend: {
          onClick: null,
        },
      },
    },
  });
};
