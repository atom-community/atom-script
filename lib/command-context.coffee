grammarMap = require './grammars'

module.exports =
class CommandContext
  command: null
  args: []

  @build: (view, runOptions, codeContext) ->
    commandContext = new CommandContext

    try
      if not runOptions.cmd? or runOptions.cmd is ''
        # Precondition: lang? and lang of grammarMap
        commandContext.command = codeContext.shebangCommand() or grammarMap[codeContext.lang][codeContext.argType].command
      else
        commandContext.command = runOptions.cmd

      buildArgsArray = grammarMap[codeContext.lang][codeContext.argType].args

    catch error
      view.createGitHubIssueLink codeContext
      return false

    try
      commandContext.args = buildArgsArray codeContext
    catch errorSendByArgs
      view.handleError errorSendByArgs
      return false

    # Return setup information
    commandContext
