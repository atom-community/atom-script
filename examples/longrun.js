var i = 1;
var run = setInterval(function() {
  console.log("line " + i);
  i++;
  if (i == 20) {
    stop();
  }
}, 1000);
function stop() {
  clearInterval(run);
}
