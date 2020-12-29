GrammarUtils = require '../grammar-utils'

exports.Perl =
  'Selection Based':
    command: 'perl'
    args: (context) ->
      code = context.getCode()
      tmpFile = GrammarUtils.createTempFileWithCode(code)
      return [tmpFile]

  'File Based':
    command: 'perl'
    args: ({filepath}) -> [filepath]

exports['Raku'] =
  'Selection Based':
    command: 'raku'
    args: (context) -> ['-e', context.getCode()]

  'File Based':
    command: 'raku'
    args: ({filepath}) -> [filepath]

exports['Perl 6'] = exports['Raku']
