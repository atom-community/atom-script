# Public: GrammarUtils.CoffeeScript - a module which predetermines the active
# CoffeeScript compiler and sets an [array] of appropriate command line flags.
{execSync} = require 'child_process' #exec TODO async?

args = ['-e']
try # Predetermine CoffeeScript compiler
  coffee = execSync 'coffee -h' #which coffee | xargs readlink'
  if coffee.toString().match /--cli/ #-redux
    args.push '--cli'
catch err
  console.error "Unable to find coffee."

exports.args = args
exports.filepath = atom.workspace.getActiveTextEditor().getTitle()
