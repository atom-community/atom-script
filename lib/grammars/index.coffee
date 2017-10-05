# Maps Atom Grammar names to the command used by that language
# As well as any special setup for arguments.

path = require 'path'
{OperatingSystem} = GrammarUtils = require '../grammar-utils'

os = OperatingSystem.platform()
windows = OperatingSystem.isWindows()

module.exports =
  '1C (BSL)':
    'File Based':
      command: 'oscript'
      args: ({filepath}) -> ['-encoding=utf-8', filepath]

  Ansible:
    'File Based':
      command: 'ansible-playbook'
      args: ({filepath}) -> [filepath]

  Clojure:
    'Selection Based':
      command: 'lein'
      args: (context) -> ['exec', '-e', context.getCode()]
    'File Based':
      command: 'lein'
      args: ({filepath}) -> ['exec', filepath]

  Crystal:
    'Selection Based':
      command: 'crystal'
      args: (context) -> ['eval', context.getCode()]
    'File Based':
      command: 'crystal'
      args: ({filepath}) -> [filepath]

  D:
    'Selection Based':
      command: 'rdmd'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.D.createTempFileWithCode(code)
        return [tmpFile]
    'File Based':
      command: 'rdmd'
      args: ({filepath}) -> [filepath]

  Elixir:
    'Selection Based':
      command: 'elixir'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'elixir'
      args: ({filepath}) -> ['-r', filepath]

  Erlang:
    'Selection Based':
      command: 'erl'
      args: (context) -> ['-noshell', '-eval', "#{context.getCode()}, init:stop()."]

  'F*':
    'File Based':
      command: 'fstar'
      args: ({filepath}) -> [filepath]

  'F#':
    'File Based':
      command: if windows then 'fsi' else 'fsharpi'
      args: ({filepath}) -> ['--exec', filepath]

  Forth:
    'File Based':
      command: 'gforth'
      args: ({filepath}) -> [filepath]

  Gherkin:
    'File Based':
      command: 'cucumber'
      args: ({filepath}) -> ['--color', filepath]
    'Line Number Based':
      command: 'cucumber'
      args: (context) -> ['--color', context.fileColonLine()]

  Go:
    'File Based':
      command: 'go'
      workingDirectory: atom.workspace.getActivePaneItem()?.buffer?.file?.getParent?().getPath?()
      args: ({filepath}) ->
        if filepath.match(/_test.go/) then ['test', '']
        else ['run', filepath]

  Groovy:
    'Selection Based':
      command: 'groovy'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'groovy'
      args: ({filepath}) -> [filepath]

  Hy:
    'Selection Based':
      command: 'hy'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code, '.hy')
        return [tmpFile]
    'File Based':
      command: 'hy'
      args: ({filepath}) -> [filepath]

  Idris:
    'File Based':
      command: 'idris'
      args: ({filepath}) -> [filepath, '-o', path.basename(filepath, path.extname(filepath))]

  InnoSetup:
    'File Based':
      command: 'ISCC.exe'
      args: ({filepath}) -> ['/Q', filepath]

  ioLanguage:
    'Selection Based':
      command: 'io'
      args: (context) -> [context.getCode()]
    'File Based':
      command: 'io'
      args: ({filepath}) -> ['-e', filepath]

  Jolie:
    'File Based':
      command: 'jolie'
      args: ({filepath}) -> [filepath]

  Julia:
    'Selection Based':
      command: 'julia'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'julia'
      args: ({filepath}) -> [filepath]

  LAMMPS:
    if os in ['darwin', 'linux']
      'File Based':
        command: 'lammps'
        args: ({filepath}) -> ['-log', 'none', '-in', filepath]

  LilyPond:
    'File Based':
      command: 'lilypond'
      args: ({filepath}) -> [filepath]

  LiveScript:
    'Selection Based':
      command: 'lsc'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'lsc'
      args: ({filepath}) -> [filepath]

  Makefile:
    'Selection Based':
      command: 'bash'
      args: (context) -> ['-c', context.getCode()]
    'File Based':
      command: 'make'
      args: ({filepath}) -> ['-f', filepath]

  MATLAB:
    'Selection Based':
      command: 'matlab'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.MATLAB.createTempFileWithCode(code)
        return ['-nodesktop', '-nosplash', '-r', "try, run('#{tmpFile}');while ~isempty(get(0,'Children')); pause(0.5); end; catch ME; disp(ME.message); exit(1); end; exit(0);"]
    'File Based':
      command: 'matlab'
      args: ({filepath}) -> ['-nodesktop', '-nosplash', '-r', "try run('#{filepath}');while ~isempty(get(0,'Children')); pause(0.5); end; catch ME; disp(ME.message); exit(1); end; exit(0);"]

  'MIPS Assembler':
    'File Based':
      command: 'spim'
      args: ({filepath}) -> ['-f', filepath]

  NCL:
    'Selection Based':
      command: 'ncl'
      args: (context) ->
        code = context.getCode() + '\n\nexit'
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        return [tmpFile]
    'File Based':
      command: 'ncl'
      args: ({filepath}) -> [filepath]

  Nim:
    'File Based':
      command: 'bash'
      args: ({filepath}) ->
        file = GrammarUtils.Nim.findNimProjectFile(filepath)
        path = GrammarUtils.Nim.projectDir(filepath)
        return ['-c', "cd '#{path}' && nim c --hints:off --parallelBuild:1 -r '#{file}' 2>&1"]

  NSIS:
    'Selection Based':
      command: 'makensis'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        return [tmpFile]
    'File Based':
      command: 'makensis'
      args: ({filepath}) -> [filepath]

  Octave:
    'Selection Based':
      command: 'octave'
      args: (context) -> ['-p', context.filepath.replace(/[^\/]*$/, ''), '--eval', context.getCode()]
    'File Based':
      command: 'octave'
      args: ({filepath}) -> ['-p', filepath.replace(/[^\/]*$/, ''), filepath]

  Oz:
    'Selection Based':
      command: 'ozc'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        return ['-c', tmpFile]
    'File Based':
      command: 'ozc'
      args: ({filepath}) -> ['-c', filepath]

  Pascal:
    'Selection Based':
      command: 'fsc'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        return [tmpFile]
    'File Based':
      command: 'fsc'
      args: ({filepath}) -> [filepath]

  Prolog:
    'File Based':
      command: 'bash'
      args: ({filepath}) -> ['-c', "cd '" + filepath.replace(/[^\/]*$/, '') + "'; swipl -f '#{filepath}' -t main --quiet"]

  PureScript:
    'File Based':
      command: if windows then 'cmd' else 'bash'
      args: ({filepath}) ->
        filepath = filepath.replace(/[^\/]*$/, '')
        command = "cd '#{filepath}' && pulp run"
        if windows then ["/c #{command}"] else ['-c', command]

  R:
    'Selection Based':
      command: 'Rscript'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.R.createTempFileWithCode(code)
        return [tmpFile]
    'File Based':
      command: 'Rscript'
      args: ({filepath}) -> [filepath]

  Racket:
    'Selection Based':
      command: 'racket'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'racket'
      args: ({filepath}) -> [filepath]

  "Ren'Py":
    'File Based':
      command: 'renpy'
      args: ({filepath}) -> [filepath.substr(0, filepath.lastIndexOf('/game'))]

  'Robot Framework':
    'File Based':
      command: 'robot'
      args: ({filepath}) -> [filepath]

  Rust:
    'File Based':
      command: if windows then 'cmd' else 'bash'
      args: ({filepath, filename}) ->
        progname = filename.replace /\.rs$/, ''
        if windows
          return ["/c rustc #{filepath} && #{progname}.exe"]
        else ['-c', "rustc '#{filepath}' -o /tmp/rs.out && /tmp/rs.out"]

  Scala:
    'Selection Based':
      command: 'scala'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'scala'
      args: ({filepath}) -> [filepath]

  Stata:
    'Selection Based':
      command: 'stata'
      args: (context) -> ['do', context.getCode()]
    'File Based':
      command: 'stata'
      args: ({filepath}) -> ['do', filepath]

  Turing:
    'File Based':
      command: 'turing'
      args: ({filepath}) -> ['-run', filepath]
