process.stdin.setEncoding('utf8');

process.stdin.on('readable', () => {
  const chunk = process.stdin.read();
  if (chunk) {
    console.log(`TEST: ${chunk}`);
  }
});
