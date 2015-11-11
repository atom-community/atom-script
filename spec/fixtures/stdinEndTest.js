process.stdin.resume();
process.stdin.setEncoding('utf8');

process.stdin.on('end', function() {
  console.log("stdin terminated");
});
