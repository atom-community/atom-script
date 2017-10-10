_ = require 'underscore'
GrammarUtils = require '../grammar-utils'

module.exports =

  'Common Lisp':
    'File Based':
      command: 'clisp'
      args: ({filepath}) -> [filepath]

  Lisp:
    'Selection Based':
      command: 'sbcl'
      args: (context) ->
        statements = _.flatten(_.map(GrammarUtils.Lisp.splitStatements(context.getCode()), (statement) -> ['--eval', statement]))
        return _.union ['--noinform', '--disable-debugger', '--non-interactive', '--quit'], statements

    'File Based':
      command: 'sbcl'
      args: ({filepath}) -> ['--noinform', '--script', filepath]

  newLISP:
    'Selection Based':
      command: 'newlisp'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'newlisp'
      args: ({filepath}) -> [filepath]

  Scheme:
    'Selection Based':
      command: 'guile'
      args: (context) -> ['-c', context.getCode()]
    'File Based':
      command: 'guile'
      args: ({filepath}) -> [filepath]
