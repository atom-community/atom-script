'use babel';

import _ from 'underscore';

// Public: GrammarUtils.Lisp - a module which exposes the ability to evaluate
// code
export default {
  // Public: Split a string of code into an array of executable statements
  //
  // Returns an {Array} of executable statements.
  splitStatements(code) {
    const iterator = (statements, currentCharacter) => {
      if (!this.parenDepth) this.parenDepth = 0;
      if (currentCharacter === '(') {
        this.parenDepth += 1;
        this.inStatement = true;
      } else if (currentCharacter === ')') {
        this.parenDepth -= 1;
      }

      if (!this.statement) this.statement = '';
      this.statement += currentCharacter;

      if (this.parenDepth === 0 && this.inStatement) {
        this.inStatement = false;
        statements.push(this.statement.trim());
        this.statement = '';
      }

      return statements;
    };

    const statements = _.reduce(code.trim(), iterator, [], {});

    return statements;
  },
};
