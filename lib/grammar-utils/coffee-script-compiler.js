'use babel';
// Public: GrammarUtils.CScompiler - a module which predetermines the active
// CoffeeScript compiler and sets an [array] of appropriate command line flags
import { execSync } from 'child_process';

let args = ['-e'];
try {
  let coffee = execSync('coffee -h'); //which coffee | xargs readlink'
  if (coffee.toString().match(/--cli/)) { //-redux
    args.push('--cli');
  }
} catch (error) {}

export { args };
