'use babel';

import GrammarUtils from '../../lib/grammar-utils';

describe('GrammarUtils', () =>
  describe('Lisp', () => {
    const toStatements = GrammarUtils.Lisp.splitStatements;

    it('returns empty array for empty code', () => {
      const code = '';
      expect(toStatements(code)).toEqual([]);
    });

    it('does not split single statement', () => {
      const code = '(print "dummy")';
      expect(toStatements(code)).toEqual([code]);
    });

    it('splits two simple statements', () => {
      const code = '(print "dummy")(print "statement")';
      expect(toStatements(code)).toEqual(['(print "dummy")', '(print "statement")']);
    });

    it('splits two simple statements in many lines', () => {
      const code = '(print "dummy")  \n\n  (print "statement")';
      expect(toStatements(code)).toEqual(['(print "dummy")', '(print "statement")']);
    });

    it('does not split single line complex statement', () => {
      const code = '(when t(setq a 2)(+ i 1))';
      expect(toStatements(code)).toEqual(['(when t(setq a 2)(+ i 1))']);
    });

    it('does not split multi line complex statement', () => {
      const code = '(when t(setq a 2)  \n \t (+ i 1))';
      expect(toStatements(code)).toEqual(['(when t(setq a 2)  \n \t (+ i 1))']);
    });

    it('splits single line complex statements', () => {
      const code = '(when t(setq a 2)(+ i 1))(when t(setq a 5)(+ i 3))';
      expect(toStatements(code)).toEqual(['(when t(setq a 2)(+ i 1))', '(when t(setq a 5)(+ i 3))']);
    });

    it('splits multi line complex statements', () => {
      const code = '(when t(\nsetq a 2)(+ i 1))   \n\t (when t(\n\t  setq a 5)(+ i 3))';
      expect(toStatements(code)).toEqual(['(when t(\nsetq a 2)(+ i 1))', '(when t(\n\t  setq a 5)(+ i 3))']);
    });
  }),
);
