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

exports['Perl 6'] =
  'Selection Based':
    command: 'perl6'
    args: (context) -> ['-e', context.getCode()]

  'File Based':
    command: 'perl6'
    args: ({filepath}) -> [filepath]

exports['Perl 6 FE'] = exports['Perl 6']
