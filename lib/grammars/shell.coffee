GrammarUtils = require '../grammar-utils'

exports['Bash Automated Test System (Bats)'] =
  'Selection Based':
    command: 'bats'
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code)
      return [tmpFile]

  'File Based':
    command: 'bats'
    args: ({filepath}) -> [filepath]

exports.Bash =
  'Selection Based':
    command: process.env.SHELL
    args: (context) -> ['-c', context.getCode()]

  'File Based':
    command: process.env.SHELL
    args: ({filepath}) -> [filepath]

exports['Shell Script'] = exports.Bash

exports['Shell Script (Fish)'] =
  'Selection Based':
    command: 'fish'
    args: (context) -> ['-c', context.getCode()]

  'File Based':
    command: 'fish'
    args: ({filepath}) -> [filepath]

exports.Tcl =
  'Selection Based':
    command: 'tclsh'
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code)
      return [tmpFile]

  'File Based':
    command: 'tclsh'
    args: ({filepath}) -> [filepath]
