grammarMap = require './grammars'

module.exports =
class CommandContext
  command: null
  args: []

  @build: (runtime, runOptions, codeContext) ->
    commandContext = new CommandContext

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

    # Return setup information
    commandContext
