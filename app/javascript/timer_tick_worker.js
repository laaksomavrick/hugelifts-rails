const timerTickWorkerFactory = () => {
  return new Worker('/timer_tick_worker.js');
};

export default timerTickWorkerFactory;
