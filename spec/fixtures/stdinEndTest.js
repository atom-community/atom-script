process.stdin.resume();
process.stdin.setEncoding('utf8');

process.stdin.on('end', () => {
  console.log('stdin terminated');
});
