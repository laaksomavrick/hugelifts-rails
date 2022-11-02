const ONE_SECOND = 1000;
const TWO_MINUTES = 120;

let ticks = TWO_MINUTES;

setInterval(function() {
    ticks = ticks - 1;

    if (ticks < 0) {
        return;
    }

    postMessage(ticks);

}, ONE_SECOND);