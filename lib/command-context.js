grammarMap = require './grammars'

module.exports =
class CommandContext
  command: null
  workingDirectory: null
  args: []
  options: {}

  @build: (runtime, runOptions, codeContext) ->
    commandContext = new CommandContext
    commandContext.options = runOptions

    try
      if not runOptions.cmd? or runOptions.cmd is ''
        # Precondition: lang? and lang of grammarMap
        commandContext.command = codeContext.shebangCommand() or grammarMap[codeContext.lang][codeContext.argType].command
      else
        commandContext.command = runOptions.cmd

      buildArgsArray = grammarMap[codeContext.lang][codeContext.argType].args

    catch error
      runtime.modeNotSupported(codeContext.argType, codeContext.lang)
      return false

    try
      commandContext.args = buildArgsArray codeContext
    catch errorSendByArgs
      runtime.didNotBuildArgs errorSendByArgs
      return false

    if not runOptions.workingDirectory? or runOptions.workingDirectory is ''
      # Precondition: lang? and lang of grammarMap
      commandContext.workingDirectory = grammarMap[codeContext.lang][codeContext.argType].workingDirectory or ''
    else
      commandContext.workingDirectory = runOptions.workingDirectory
    
    # Return setup information
    commandContext

  quoteArguments: (args) ->
    ((if arg.trim().indexOf(' ') == -1 then arg.trim() else "'#{arg}'") for arg in args)

  getRepresentation: ->
    return '' if !@command or !@args.length

    # command arguments
    commandArgs = if @options.cmdArgs? then @quoteArguments(@options.cmdArgs).join ' ' else ''

    # script arguments
    args = if @args.length then @quoteArguments(@args).join ' ' else ''
    scriptArgs = if @options.scriptArgs? then @quoteArguments(@options.scriptArgs).join ' ' else ''

    @command.trim() +
      (if commandArgs then ' ' + commandArgs else '') +
      (if args then ' ' + args else '') +
      (if scriptArgs then ' ' + scriptArgs else '')
