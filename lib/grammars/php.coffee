GrammarUtils = require '../grammar-utils'

module.exports =

  'Behat Feature':

    'File Based':
      command: 'behat'
      args: ({filepath}) -> [filepath]

    'Line Number Based':
      command: 'behat'
      args: (context) -> [context.fileColonLine()]

  PHP:
    'Selection Based':
      command: 'php'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.PHP.createTempFileWithCode(code)
        return [tmpFile]

    'File Based':
      command: 'php'
      args: ({filepath}) -> [filepath]
