# Maps Atom Grammar names to the command used by that language
# As well as any special setup for arguments.

path = require 'path'
{shell} = require 'electron'
_ = require 'underscore'
{OperatingSystem} = GrammarUtils = require '../lib/grammar-utils'

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

  AppleScript:
    'Selection Based':
      command: 'osascript'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'osascript'
      args: ({filepath}) -> [filepath]

  AutoHotKey:
    'Selection Based':
      command: 'AutoHotKey'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        return [tmpFile]
    'File Based':
      command: 'AutoHotKey'
      args: ({filepath}) -> [filepath]

  'Babel ES6 JavaScript':
    'Selection Based':
      command: 'babel-node'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'babel-node'
      args: (context) -> [context.filepath]

  'Bash Automated Test System (Bats)':
    'Selection Based':
      command: 'bats'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        return [tmpFile]
    'File Based':
      command: 'bats'
      args: ({filepath}) -> [filepath]

  Batch:
    'File Based':
      command: 'cmd.exe'
      args: ({filepath}) -> ['/q', '/c', filepath]

  'Behat Feature':
    'File Based':
      command: 'behat'
      args: ({filepath}) -> [filepath]
    'Line Number Based':
      command: 'behat'
      args: (context) -> [context.fileColonLine()]

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

  C:
    'File Based':
      command: 'bash'
      args: ({filepath}) ->
        args = switch os
          when 'darwin'
            "xcrun clang -fcolor-diagnostics -Wall -include stdio.h '#{filepath}' -o /tmp/c.out && /tmp/c.out"
          when 'linux'
            "cc -Wall -include stdio.h '#{filepath}' -o /tmp/c.out && /tmp/c.out"
        return ['-c', args]

    'Selection Based':
      command: 'bash'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code, '.c')
        args = switch os
          when 'darwin'
            "xcrun clang -fcolor-diagnostics -Wall -include stdio.h #{tmpFile} -o /tmp/c.out && /tmp/c.out"
          when 'linux'
            "cc -Wall -include stdio.h #{tmpFile} -o /tmp/c.out && /tmp/c.out"
        return ['-c', args]

  'C#':
    'Selection Based':
      command: if windows then 'cmd' else 'bash'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code, '.cs')
        progname = tmpFile.replace /\.cs$/, ''
        if windows
          return ["/c csc /out:#{progname}.exe #{tmpFile} && #{progname}.exe"]
        else ['-c', "csc /out:#{progname}.exe #{tmpFile} && mono #{progname}.exe"]

    'File Based':
      command: if windows then 'cmd' else 'bash'
      args: ({filepath, filename}) ->
        progname = filename.replace /\.cs$/, ''
        if windows
          return ["/c csc #{filepath} && #{progname}.exe"]
        else ['-c', "csc '#{filepath}' && mono #{progname}.exe"]

  'C# Script File':
    'Selection Based':
      command: 'scriptcs'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code, '.csx')
        return ['-script', tmpFile]
    'File Based':
      command: 'scriptcs'
      args: ({filepath}) -> ['-script', filepath]

  'C++':
    'Selection Based':
      command: 'bash'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code, '.cpp')
        args = switch os
          when 'darwin'
            "xcrun clang++ -fcolor-diagnostics -std=c++14 -Wall -include stdio.h -include iostream #{tmpFile} -o /tmp/cpp.out && /tmp/cpp.out"
          when 'linux'
            "g++ -std=c++14 -Wall -include stdio.h -include iostream #{tmpFile} -o /tmp/cpp.out && /tmp/cpp.out"
        return ['-c', args]

    'File Based':
      command: 'bash'
      args: ({filepath}) ->
        args = switch os
          when 'darwin'
            "xcrun clang++ -fcolor-diagnostics -std=c++14 -Wall -include stdio.h -include iostream '#{filepath}' -o /tmp/cpp.out && /tmp/cpp.out"
          when 'linux'
            "g++ -std=c++14 -Wall -include stdio.h -include iostream '#{filepath}' -o /tmp/cpp.out && /tmp/cpp.out"
          when 'win32'
            if GrammarUtils.OperatingSystem.release().split('.').slice -1 >= '14399'
              filepath = path.posix.join.apply(path.posix, [].concat([filepath.split(path.win32.sep)[0].toLowerCase()], filepath.split(path.win32.sep).slice(1))).replace(':', '')
              "g++ -std=c++14 -Wall -include stdio.h -include iostream '/mnt/#{filepath}' -o /tmp/cpp.out && /tmp/cpp.out"
        return ['-c', args]

  'C++14':
    'Selection Based':
      command: 'bash'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code, '.cpp')
        args = switch os
          when 'darwin'
            "xcrun clang++ -fcolor-diagnostics -std=c++14 -Wall -include stdio.h -include iostream #{tmpFile} -o /tmp/cpp.out && /tmp/cpp.out"
          when 'linux'
            "g++ -std=c++14 -Wall -include stdio.h -include iostream #{tmpFile} -o /tmp/cpp.out && /tmp/cpp.out"
        return ['-c', args]

    'File Based':
      command: 'bash'
      args: ({filepath}) ->
        args = switch os
          when 'darwin'
            "xcrun clang++ -fcolor-diagnostics -std=c++14 -Wall -include stdio.h -include iostream '#{filepath}' -o /tmp/cpp.out && /tmp/cpp.out"
          when 'linux'
            "g++ -std=c++14 -Wall -include stdio.h -include iostream '#{filepath}' -o /tmp/cpp.out && /tmp/cpp.out"
          when 'win32'
            if GrammarUtils.OperatingSystem.release().split('.').slice -1 >= '14399'
              filepath = path.posix.join.apply(path.posix, [].concat([filepath.split(path.win32.sep)[0].toLowerCase()], filepath.split(path.win32.sep).slice(1))).replace(':', '')
              "g++ -std=c++14 -Wall -include stdio.h -include iostream '/mnt/#{filepath}' -o /tmp/cpp.out && /tmp/cpp.out"
        return ['-c', args]

  Clojure:
    'Selection Based':
      command: 'lein'
      args: (context) -> ['exec', '-e', context.getCode()]
    'File Based':
      command: 'lein'
      args: ({filepath}) -> ['exec', filepath]

  CoffeeScript:
    'Selection Based':
      command: 'coffee'
      args: (context) -> ['--transpile', '-e', context.getCode()]
    'File Based':
      command: 'coffee'
      args: ({filepath}) -> ['-t', filepath]

  'CoffeeScript (Literate)':
    'Selection Based':
      command: 'coffee'
      args: (context) -> ['-t', '-e', context.getCode()]
    'File Based':
      command: 'coffee'
      args: ({filepath}) -> ['-t', filepath]

  'Common Lisp':
    'File Based':
      command: 'clisp'
      args: ({filepath}) -> [filepath]

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

  Dart:
    'Selection Based':
      command: 'dart'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code, '.dart')
        return [tmpFile]
    'File Based':
      command: 'dart'
      args: ({filepath}) -> [filepath]

  DOT:
    'Selection Based':
      command: 'dot'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code, '.dot')
        ['-Tpng', tmpFile, '-o', tmpFile + '.png']
    'File Based':
      command: 'dot'
      args: ({filepath}) -> ['-Tpng', filepath, '-o', filepath + '.png']

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

  Fable:
    'Selection Based':
      command: 'fable'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        return [tmpFile]
    'File Based':
      command: 'fable'
      args: ({filepath}) -> [filepath]

  Forth:
    'File Based':
      command: 'gforth'
      args: ({filepath}) -> [filepath]

  'Fortran - Fixed Form':
    'File Based':
      command: 'bash'
      args: ({filepath}) -> ['-c', "gfortran '#{filepath}' -ffixed-form -o /tmp/f.out && /tmp/f.out"]

  'Fortran - Free Form':
    'File Based':
      command: 'bash'
      args: ({filepath}) -> ['-c', "gfortran '#{filepath}' -ffree-form -o /tmp/f90.out && /tmp/f90.out"]

  'Fortran - Modern':
    'File Based':
      command: 'bash'
      args: ({filepath}) -> ['-c', "gfortran '#{filepath}' -ffree-form -o /tmp/f90.out && /tmp/f90.out"]

  'Fortran - Punchcard':
    'File Based':
      command: 'bash'
      args: ({filepath}) -> ['-c', "gfortran '#{filepath}' -ffixed-form -o /tmp/f.out && /tmp/f.out"]

  'Free Pascal':
    'Selection Based':
      command: 'fsc'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        return [tmpFile]
    'File Based':
      command: 'fsc'
      args: ({filepath}) -> [filepath]

  Gherkin:
    'File Based':
      command: 'cucumber'
      args: ({filepath}) -> ['--color', filepath]
    'Line Number Based':
      command: 'cucumber'
      args: (context) -> ['--color', context.fileColonLine()]

  gnuplot:
    'File Based':
      command: 'gnuplot'
      workingDirectory: atom.workspace.getActivePaneItem()?.buffer?.file?.getParent?().getPath?()
      args: ({filepath}) -> ['-p', filepath]

  Go:
    'File Based':
      command: 'go'
      workingDirectory: atom.workspace.getActivePaneItem()?.buffer?.file?.getParent?().getPath?()
      args: ({filepath}) ->
        if filepath.match(/_test.go/) then ['test', '']
        else ['run', filepath]

  'Graphviz (DOT)':
    'Selection Based':
      command: 'dot'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code, '.dot')
        return ['-Tpng', tmpFile, '-o', tmpFile + '.png']
    'File Based':
      command: 'dot'
      args: ({filepath}) -> ['-Tpng', filepath, '-o', filepath + '.png']

  Groovy:
    'Selection Based':
      command: 'groovy'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'groovy'
      args: ({filepath}) -> [filepath]

  Haskell:
    'Selection Based':
      command: 'ghc'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'runhaskell'
      args: ({filepath}) -> [filepath]

  HTML:
    'File Based':
      command: 'echo'
      args: ({filepath}) ->
        uri = 'file://' + filepath
        shell.openExternal(uri)
        return ['HTML file opened at:', uri]

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

  IcedCoffeeScript:
    'Selection Based':
      command: 'iced'
      args: (context)  -> ['-e', context.getCode()]
    'File Based':
      command: 'iced'
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

  Java:
    'File Based':
      command: if windows then 'cmd' else 'bash'
      args: (context) ->
        className = GrammarUtils.Java.getClassName context
        classPackages = GrammarUtils.Java.getClassPackage context
        sourcePath = GrammarUtils.Java.getProjectPath context
        if windows
          return ["/c javac -Xlint '#{context.filename}' && java #{className}"]
        else ['-c', "javac -sourcepath #{sourcePath} -d /tmp '#{context.filepath}' && java -cp /tmp #{classPackages}#{className}"]

  JavaScript:
    'Selection Based':
      command: 'babel-node'
      args: (context)  -> ['-e', context.getCode()]
    'File Based':
      command: 'babel-node'
      args: ({filepath}) -> [filepath]

  'JavaScript for Automation (JXA)':
    'Selection Based':
      command: 'osascript'
      args: (context)  -> ['-l', 'JavaScript', '-e', context.getCode()]
    'File Based':
      command: 'osascript'
      args: ({filepath}) -> ['-l', 'JavaScript', filepath]

  'JavaScript with JSX':
    'Selection Based':
      command: 'babel-node'
      args: (context)  -> ['-e', context.getCode()]
    'File Based':
      command: 'babel-node'
      args: ({filepath}) -> [filepath]

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

  Kotlin:
    'Selection Based':
      command: 'bash'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code, '.kt')
        jarName = tmpFile.replace /\.kt$/, '.jar'
        return ['-c', "kotlinc #{tmpFile} -include-runtime -d #{jarName} && java -jar #{jarName}"]
    'File Based':
      command: 'bash'
      args: ({filepath, filename}) ->
        jarName = filename.replace /\.kt$/, '.jar'
        return ['-c', "kotlinc '#{filepath}' -include-runtime -d /tmp/#{jarName} && java -jar /tmp/#{jarName}"]

  LAMMPS:
    if os in ['darwin', 'linux']
      'File Based':
        command: 'lammps'
        args: ({filepath}) -> ['-log', 'none', '-in', filepath]

  LaTeX:
    'File Based':
      command: 'latexmk'
      args: ({filepath}) -> ['-cd', '-quiet', '-pdf', '-pv', '-shell-escape', filepath]

  'LaTeX Beamer':
    'File Based':
      command: 'latexmk'
      args: ({filepath}) -> ['-cd', '-quiet', '-pdf', '-pv', '-shell-escape', filepath]

  LilyPond:
    'File Based':
      command: 'lilypond'
      args: ({filepath}) -> [filepath]

  Lisp:
    'Selection Based':
      command: 'sbcl'
      args: (context) ->
        statements = _.flatten(_.map(GrammarUtils.Lisp.splitStatements(context.getCode()), (statement) -> ['--eval', statement]))
        return _.union ['--noinform', '--disable-debugger', '--non-interactive', '--quit'], statements
    'File Based':
      command: 'sbcl'
      args: ({filepath}) -> ['--noinform', '--script', filepath]

  'Literate Haskell':
    'File Based':
      command: 'runhaskell'
      args: ({filepath}) -> [filepath]

  LiveScript:
    'Selection Based':
      command: 'lsc'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'lsc'
      args: ({filepath}) -> [filepath]

  Lua:
    'Selection Based':
      command: 'lua'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        return [tmpFile]
    'File Based':
      command: 'lua'
      args: ({filepath}) -> [filepath]

  'Lua (WoW)':
    'Selection Based':
      command: 'lua'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        return [tmpFile]
    'File Based':
      command: 'lua'
      args: ({filepath}) -> [filepath]

  MagicPython:
    'Selection Based':
      command: 'python'
      args: (context) -> ['-u', '-c', context.getCode()]
    'File Based':
      command: 'python'
      args: ({filepath}) -> ['-u', filepath]

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

  'mongoDB (JavaScript)':
    'Selection Based':
      command: 'mongo'
      args: (context) -> ['--eval', context.getCode()]
    'File Based':
      command:  'mongo'
      args: ({filepath}) -> [filepath]

  MoonScript:
    'Selection Based':
      command: 'moon'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'moon'
      args: ({filepath}) -> [filepath]

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

  newLISP:
    'Selection Based':
      command: 'newlisp'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'newlisp'
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

  'Objective-C':
    if os is 'darwin'
      'File Based':
        command: 'bash'
        args: ({filepath}) -> ['-c', "xcrun clang -fcolor-diagnostics -Wall -include stdio.h -framework Cocoa '#{filepath}' -o /tmp/objc-c.out && /tmp/objc-c.out"]

  'Objective-C++':
    if os is 'darwin'
      'File Based':
        command: 'bash'
        args: ({filepath}) -> ['-c', "xcrun clang++ -fcolor-diagnostics -Wc++11-extensions -Wall -include stdio.h -include iostream -framework Cocoa '#{filepath}' -o /tmp/objc-cpp.out && /tmp/objc-cpp.out"]

  OCaml:
    'File Based':
      command: 'ocaml'
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

  'Pandoc Markdown':
    'File Based':
      command: 'panzer'
      args: ({filepath}) -> [filepath, "--output='#{filepath}.pdf'"]

  Perl:
    'Selection Based':
      command: 'perl'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        return [tmpFile]
    'File Based':
      command: 'perl'
      args: ({filepath}) -> [filepath]

  'Perl 6':
    'Selection Based':
      command: 'perl6'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'perl6'
      args: ({filepath}) -> [filepath]

  'Perl 6 FE':
    'Selection Based':
      command: 'perl6'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'perl6'
      args: ({filepath}) -> [filepath]

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

  Povray:
    "File Based":
      command: "povray"
      args: (context) -> [context.filepath]

  PowerShell:
    'Selection Based':
      command: 'powershell'
      args: (context) -> [context.getCode()]
    'File Based':
      command: 'powershell'
      args: ({filepath}) -> [filepath.replace /\ /g, '` ']

  Processing:
    'File Based':
      command: if windows then 'cmd' else 'bash'
      args: ({filepath, filename}) ->
        if windows
          return ['/c processing-java --sketch=' + filepath.replace("\\#{filename}", '') + ' --run']
        else ['-c', 'processing-java --sketch=' + filepath.replace("/#{filename}", '') + ' --run']

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

  Python:
    'Selection Based':
      command: 'python'
      args: (context) -> ['-u', '-c', context.getCode()]
    'File Based':
      command: 'python'
      args: ({filepath}) -> ['-u', filepath]

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

  RANT:
    'Selection Based':
      command: 'RantConsole.exe'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        return ['-file', tmpFile]
    'File Based':
      command: 'RantConsole.exe'
      args: ({filepath}) -> ['-file', filepath]

  Reason:
    'File Based':
      command: if windows then 'cmd' else 'bash'
      args: ({filename}) ->
        progname = filename.replace /\.re$/, ''
        command = "rebuild '#{progname}.native' && '#{progname}.native'"
        if windows then ["/c #{command}"] else ['-c', command]

  "Ren'Py":
    'File Based':
      command: 'renpy'
      args: ({filepath}) -> [filepath.substr(0, filepath.lastIndexOf('/game'))]

  'Robot Framework':
    'File Based':
      command: 'robot'
      args: ({filepath}) -> [filepath]

  RSpec:
    'Selection Based':
      command: 'ruby'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'rspec'
      args: ({filepath}) -> ['--tty', '--color', filepath]
    'Line Number Based':
      command: 'rspec'
      args: (context) -> ['--tty', '--color', context.fileColonLine()]

  Ruby:
    'Selection Based':
      command: 'ruby'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'ruby'
      args: ({filepath}) -> [filepath]

  'Ruby on Rails':
    'Selection Based':
      command: 'rails'
      args: (context) -> ['runner', context.getCode()]
    'File Based':
      command: 'rails'
      args: ({filepath}) -> ['runner', filepath]

  Rust:
    'File Based':
      command: if windows then 'cmd' else 'bash'
      args: ({filepath, filename}) ->
        progname = filename.replace /\.rs$/, ''
        if windows
          return ["/c rustc #{filepath} && #{progname}.exe"]
        else ['-c', "rustc '#{filepath}' -o /tmp/rs.out && /tmp/rs.out"]

  Sage:
    'Selection Based':
      command: 'sage'
      args: (context) -> ['-c', context.getCode()]
    'File Based':
      command: 'sage'
      args: ({filepath}) -> [filepath]

  Sass:
    'File Based':
      command: 'sass'
      args: ({filepath}) -> [filepath]

  Scala:
    'Selection Based':
      command: 'scala'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'scala'
      args: ({filepath}) -> [filepath]

  Scheme:
    'Selection Based':
      command: 'guile'
      args: (context) -> ['-c', context.getCode()]
    'File Based':
      command: 'guile'
      args: ({filepath}) -> [filepath]

  SCSS:
    'File Based':
      command: 'sass'
      args: ({filepath}) -> [filepath]

  'Shell Script':
    'Selection Based':
      command: process.env.SHELL
      args: (context) -> ['-c', context.getCode()]
    'File Based':
      command: process.env.SHELL
      args: ({filepath}) -> [filepath]

  'Shell Script (Fish)':
    'Selection Based':
      command: 'fish'
      args: (context) -> ['-c', context.getCode()]
    'File Based':
      command: 'fish'
      args: ({filepath}) -> [filepath]

  SQL:
    'Selection Based':
      command: 'echo'
      args: -> ["SQL requires setting 'Script: Run Options' directly. See https://github.com/rgbkrk/atom-script/tree/master/examples/hello.sql for further information."]
    'File Based':
      command: 'echo'
      args: -> ["SQL requires setting 'Script: Run Options' directly. See https://github.com/rgbkrk/atom-script/tree/master/examples/hello.sql for further information."]

  'SQL (PostgreSQL)':
    'Selection Based':
      command: 'psql'
      args: (context) -> ['-c', context.getCode()]
    'File Based':
      command: 'psql'
      args: ({filepath}) -> ['-f', filepath]

  'Standard ML':
    'File Based':
      command: 'sml'
      args: ({filepath}) -> [filepath]

  Stata:
    'Selection Based':
      command: 'stata'
      args: (context) -> ['do', context.getCode()]
    'File Based':
      command: 'stata'
      args: ({filepath}) -> ['do', filepath]

  Swift:
    'File Based':
      command: 'swift'
      args: ({filepath}) -> [filepath]

  Tcl:
    'Selection Based':
      command: 'tclsh'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        return [tmpFile]
    'File Based':
      command: 'tclsh'
      args: ({filepath}) -> [filepath]

  Turing:
    'File Based':
      command: 'turing'
      args: ({filepath}) -> ['-run', filepath]

  TypeScript:
    'Selection Based':
      command: 'ts-node'
      args: (context) -> ['-e', context.getCode()]
    'File Based':
      command: 'ts-node'
      args: ({filepath}) -> [filepath]

  VBScript:
    'Selection Based':
      command: 'cscript'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code, '.vbs')
        return ['//NOLOGO', tmpFile]
    'File Based':
      command: 'cscript'
      args: ({filepath}) -> ['//NOLOGO', filepath]
