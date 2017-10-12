{command} = GrammarUtils = require '../grammar-utils'

windows = GrammarUtils.OperatingSystem.isWindows()

module.exports =

  BuckleScript:
    'Selection Based':
      command: 'bsc'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        return ['-c', tmpFile]

    'File Based':
      command: 'bsc'
      args: ({filepath}) -> ['-c', filepath]

  OCaml:
    'File Based':
      command: 'ocaml'
      args: ({filepath}) -> [filepath]

  Reason:
    'File Based': {
      command
      args: ({filename}) ->
        file = filename.replace /\.re$/, '.native'
        GrammarUtils.formatArgs("rebuild '#{file}' && '#{file}'")
    }
