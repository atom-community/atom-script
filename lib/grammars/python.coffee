GrammarUtils = require '../grammar-utils'

exports.Python =
  'Selection Based':
    command: 'python3'
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code)
      return ['-u', tmpFile]

  'File Based':
    command: 'python3'
    args: ({filepath}) -> ['-u', filepath]

exports.MagicPython = exports.Python

exports.Sage =
  'Selection Based':
    command: 'sage'
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code)
      return [tmpFile]

  'File Based':
    command: 'sage'
    args: ({filepath}) -> [filepath]
