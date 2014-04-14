crypto = require 'crypto'
fs = require 'fs'

console.log "Let's hash these bugs out"

shasum = crypto.createHash 'sha1'
shasum.update 'I like it when you sum.'
console.log shasum.digest 'hex'
