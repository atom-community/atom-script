GrammarUtils = require '../grammar-utils'

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
    'File Based':
      command: if windows then 'cmd' else 'bash'
      args: ({filename}) ->
        progname = filename.replace /\.re$/, ''
        command = "rebuild '#{progname}.native' && '#{progname}.native'"
        if windows then ["/c #{command}"] else ['-c', command]
