GrammarUtils = require '../../lib/grammar-utils'

describe 'GrammarUtils', ->
  describe 'Lisp', ->
    toStatements = GrammarUtils.Lisp.splitStatements

    it 'returns empty array for empty code', ->
      code = ''
      expect(toStatements(code)).toEqual([])

    it 'does not split single statement', ->
      code = '(print "dummy")'
      expect(toStatements(code)).toEqual([code])

    it 'splits two simple statements', ->
      code = '(print "dummy")(print "statement")'
      expect(toStatements(code)).toEqual(['(print "dummy")', '(print "statement")'])

    it 'splits two simple statements in many lines', ->
      code = '(print "dummy")  \n\n  (print "statement")'
      expect(toStatements(code)).toEqual(['(print "dummy")', '(print "statement")'])

    it 'does not split single line complex statement', ->
      code = '(when t(setq a 2)(+ i 1))'
      expect(toStatements(code)).toEqual(['(when t(setq a 2)(+ i 1))'])

    it 'does not split multi line complex statement', ->
      code = '(when t(setq a 2)  \n \t (+ i 1))'
      expect(toStatements(code)).toEqual(['(when t(setq a 2)  \n \t (+ i 1))'])

    it 'splits single line complex statements', ->
      code = '(when t(setq a 2)(+ i 1))(when t(setq a 5)(+ i 3))'
      expect(toStatements(code)).toEqual(['(when t(setq a 2)(+ i 1))', '(when t(setq a 5)(+ i 3))'])

    it 'splits multi line complex statements', ->
      code = '(when t(\nsetq a 2)(+ i 1))   \n\t (when t(\n\t  setq a 5)(+ i 3))'
      expect(toStatements(code)).toEqual(['(when t(\nsetq a 2)(+ i 1))', '(when t(\n\t  setq a 5)(+ i 3))'])
