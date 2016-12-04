# Public: GrammarUtils.CScompiler - a module which predetermines the active
# CoffeeScript compiler and sets an [array] of appropriate command line flags
{execSync} = require 'child_process'

args = ['-e']
try
  coffee = execSync 'coffee -h' #which coffee | xargs readlink'
  if coffee.toString().match /--cli/ #-redux
    args.push '--cli'

exports.args = args
