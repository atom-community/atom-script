'use babel';

// Public: GrammarUtils.CScompiler - a module which predetermines the active
// CoffeeScript compiler and sets an [array] of appropriate command line flags
import { execSync } from 'child_process';

const args = ['-e'];
try {
  const coffee = execSync('coffee -h'); // which coffee | xargs readlink'
  if (coffee.toString().match(/--cli/)) { // -redux
    args.push('--cli');
  }
} catch (error) { /* Don't throw */ }

export default { args };
