'use babel';

import grammarMap from './grammars.coffee';

export default class CommandContext {
  constructor() {
    this.command = null;
    this.workingDirectory = null;
    this.args = [];
    this.options = {};
  }

  static build(runtime, runOptions, codeContext) {
    const commandContext = new CommandContext();
    commandContext.options = runOptions;
    let buildArgsArray;

    try {
      if (!runOptions.cmd) {
        // Precondition: lang? and lang of grammarMap
        commandContext.command = codeContext.shebangCommand() ||
          grammarMap[codeContext.lang][codeContext.argType].command;
      } else {
        commandContext.command = runOptions.cmd;
      }

      buildArgsArray = grammarMap[codeContext.lang][codeContext.argType].args;
    } catch (error) {
      runtime.modeNotSupported(codeContext.argType, codeContext.lang);
      return false;
    }

    try {
      commandContext.args = buildArgsArray(codeContext);
    } catch (errorSendByArgs) {
      runtime.didNotBuildArgs(errorSendByArgs);
      return false;
    }

    if (!runOptions.workingDirectory) {
      // Precondition: lang? and lang of grammarMap
      commandContext.workingDirectory = grammarMap[codeContext.lang][codeContext.argType].workingDirectory || '';
    } else {
      commandContext.workingDirectory = runOptions.workingDirectory;
    }

    // Return setup information
    return commandContext;
  }

  quoteArguments(args) {
    return args.map(arg => (arg.trim().indexOf(' ') === -1 ? arg.trim() : `'${arg}'`));
  }

  getRepresentation() {
    if (!this.command || !this.args.length) return '';

    // command arguments
    const commandArgs = this.options.cmdArgs ? this.quoteArguments(this.options.cmdArgs).join(' ') : '';

    // script arguments
    const args = this.args.length ? this.quoteArguments(this.args).join(' ') : '';
    const scriptArgs = this.options.scriptArgs ? this.quoteArguments(this.options.scriptArgs).join(' ') : '';

    return this.command.trim() +
      (commandArgs ? ` ${commandArgs}` : '') +
      (args ? ` ${args}` : '') +
      (scriptArgs ? ` ${scriptArgs}` : '');
  }
}
