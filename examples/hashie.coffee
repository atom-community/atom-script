crypto = require('crypto');
fs = require('fs');

shasum = crypto.createHash('sha1');
shasum.update("Some text")
console.log(shasum.digest('hex'))
