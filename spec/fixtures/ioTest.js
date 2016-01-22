process.stdin.setEncoding('utf8');

process.stdin.on('readable', function() {
  var chunk = process.stdin.read();
   if (chunk !== null) {
     console.log('TEST: ' + chunk);
   }
});
