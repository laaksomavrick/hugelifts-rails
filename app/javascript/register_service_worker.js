const registerServiceWorker = async () => {
  try {
    if (!('serviceWorker' in navigator)) {
      console.warn('Service workers are not supported.');
      return;
    }
    await navigator.serviceWorker.register('/sw.js');
    console.log('Service worker registered');
  } catch (e) {
    console.warn('Something went wrong registering service worker', e);
  }
};

export default registerServiceWorker;
