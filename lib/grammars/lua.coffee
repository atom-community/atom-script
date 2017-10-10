GrammarUtils = require '../grammar-utils'

exports.Lua =
  'Selection Based':
    command: 'lua'
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code)
      return [tmpFile]

  'File Based':
    command: 'lua'
    args: ({filepath}) -> [filepath]

exports['Lua (WoW)'] = exports.Lua

exports.MoonScript =
  'Selection Based':
    command: 'moon'
    args: (context) -> ['-e', context.getCode()]

  'File Based':
    command: 'moon'
    args: ({filepath}) -> [filepath]
