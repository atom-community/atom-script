'use babel';

import { Emitter, BufferedProcess } from 'atom';
import fs from 'fs';
import path from 'path';

export default class Runner {
  static initClass() {
    this.prototype.bufferedProcess = null;
  }

  // Public: Creates a Runner instance
  //
  // * `scriptOptions` a {ScriptOptions} object instance
  // * `emitter` Atom's {Emitter} instance. You probably don't need to overwrite it
  constructor(scriptOptions, emitter = new Emitter()) {
    this.stdoutFunc = this.stdoutFunc.bind(this);
    this.stderrFunc = this.stderrFunc.bind(this);
    this.onExit = this.onExit.bind(this);
    this.createOnErrorFunc = this.createOnErrorFunc.bind(this);
    this.scriptOptions = scriptOptions;
    this.emitter = emitter;
  }

  run(command, extraArgs, codeContext, inputString = null) {
    this.startTime = new Date();

    const args = this.args(codeContext, extraArgs);
    const options = this.options();
    const stdout = this.stdoutFunc;
    const stderr = this.stderrFunc;
    const exit = this.onExit;

    this.bufferedProcess = new BufferedProcess({
      command, args, options, stdout, stderr, exit,
    });

    if (inputString) {
      this.bufferedProcess.process.stdin.write(inputString);
      this.bufferedProcess.process.stdin.end();
    }

    return this.bufferedProcess.onWillThrowError(this.createOnErrorFunc(command));
  }

  stdoutFunc(output) {
    return this.emitter.emit('did-write-to-stdout', { message: output });
  }

  onDidWriteToStdout(callback) {
    return this.emitter.on('did-write-to-stdout', callback);
  }

  stderrFunc(output) {
    return this.emitter.emit('did-write-to-stderr', { message: output });
  }

  onDidWriteToStderr(callback) {
    return this.emitter.on('did-write-to-stderr', callback);
  }

  destroy() {
    return this.emitter.dispose();
  }

  getCwd() {
    let cwd = this.scriptOptions.workingDirectory;

    const workingDirectoryProvided = (cwd != null) && cwd !== '';
    if (!workingDirectoryProvided) {
      switch (atom.config.get('script.cwdBehavior')) {
        case 'First project directory':
          const paths = atom.project.getPaths();
          if (__guard__(paths, x => x.length) > 0) {
            try {
              cwd = fs.statSync(paths[0]).isDirectory() ? paths[0] : path.join(paths[0], '..');
            } catch (error) {}
          }
          break;
        case 'Project directory of the script':
          cwd = this.getProjectPath();
          break;
        case 'Directory of the script':
          cwd = __guardMethod__(__guardMethod__(__guard__(__guard__(atom.workspace.getActivePaneItem(), x2 => x2.buffer), x1 => x1.file), 'getParent', o1 => o1.getParent()), 'getPath', o => o.getPath()) || '';
          break;
      }
    }
    return cwd;
  }

  stop() {
    if (this.bufferedProcess != null) {
      this.bufferedProcess.kill();
      return this.bufferedProcess = null;
    }
  }

  onExit(returnCode) {
    this.bufferedProcess = null;

    if ((atom.config.get('script.enableExecTime')) === true && this.startTime) {
      var executionTime = (new Date().getTime() - this.startTime.getTime()) / 1000;
    }

    return this.emitter.emit('did-exit', { executionTime, returnCode });
  }

  onDidExit(callback) {
    return this.emitter.on('did-exit', callback);
  }

  createOnErrorFunc(command) {
    return (nodeError) => {
      this.bufferedProcess = null;
      this.emitter.emit('did-not-run', { command });
      return nodeError.handle();
    };
  }

  onDidNotRun(callback) {
    return this.emitter.on('did-not-run', callback);
  }

  options() {
    return {
      cwd: this.getCwd(),
      env: this.scriptOptions.mergedEnv(process.env),
    };
  }

  fillVarsInArg(arg, codeContext, project_path) {
    if (codeContext.filepath != null) {
      arg = arg.replace(/{FILE_ACTIVE}/g, codeContext.filepath);
      arg = arg.replace(/{FILE_ACTIVE_PATH}/g, path.join(codeContext.filepath, '..'));
    }
    if (codeContext.filename != null) {
      arg = arg.replace(/{FILE_ACTIVE_NAME}/g, codeContext.filename);
      arg = arg.replace(/{FILE_ACTIVE_NAME_BASE}/g, path.basename(codeContext.filename, path.extname(codeContext.filename)));
    }
    if (project_path != null) {
      arg = arg.replace(/{PROJECT_PATH}/g, project_path);
    }

    return arg;
  }

  args(codeContext, extraArgs) {
    let args = (this.scriptOptions.cmdArgs.concat(extraArgs)).concat(this.scriptOptions.scriptArgs);
    const project_path = this.getProjectPath || '';
    args = (args.map(arg => this.fillVarsInArg(arg, codeContext, project_path)));

    if ((this.scriptOptions.cmd == null) || this.scriptOptions.cmd === '') {
      args = codeContext.shebangCommandArgs().concat(args);
    }
    return args;
  }

  getProjectPath() {
    const filePath = atom.workspace.getActiveTextEditor().getPath();
    const projectPaths = atom.project.getPaths();
    for (const projectPath of projectPaths) {
      if (filePath.indexOf(projectPath) > -1) {
        if (fs.statSync(projectPath).isDirectory()) {
          return projectPath;
        } else {
          return path.join(projectPath, '..');
        }
      }
    }
  }
}
Runner.initClass();

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}
function __guardMethod__(obj, methodName, transform) {
  if (typeof obj !== 'undefined' && obj !== null && typeof obj[methodName] === 'function') {
    return transform(obj, methodName);
  } else {
    return undefined;
  }
}
