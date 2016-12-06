let i = 1;
const run = setInterval(() => {
  console.log(`line ${i}`);
  i++;
  if (i === 20) {
    stop();
  }
}, 1000);
function stop() {
  clearInterval(run);
}
