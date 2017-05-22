# Maps Atom Grammar names to the command used by that language
# As well as any special setup for arguments.

_ = require 'underscore'
path = require 'path'
GrammarUtils = require '../lib/grammar-utils'
shell = require('electron').shell

module.exports =
  '1C (BSL)':
    'File Based':
      command: "oscript"
      args: (context) -> ['-encoding=utf-8', context.filepath]

  Ansible:
    "File Based":
      command: "ansible-playbook"
      args: (context) -> [context.filepath]

  AppleScript:
    'Selection Based':
      command: 'osascript'
      args: (context)  -> ['-e', context.getCode()]
    'File Based':
      command: 'osascript'
      args: (context) -> [context.filepath]

  AutoHotKey:
    "File Based":
      command: "AutoHotKey"
      args: (context) -> [context.filepath]
    "Selection Based":
      command: "AutoHotKey"
      args: (context) ->
        code = context.getCode(true)
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        [tmpFile]

  'Babel ES6 JavaScript':
    "Selection Based":
      command: "babel-node"
      args: (context) -> ['-e', context.getCode()]
    "File Based":
      command: "babel-node"
      args: (context) -> [context.filepath]

  'Bash Automated Test System (Bats)':
    "File Based":
      command: "bats"
      args: (context) -> [context.filepath]
    "Selection Based":
      command: 'bats'
      args: (context) ->
        code = context.getCode(true)
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        [tmpFile]

  Batch:
    "File Based":
      command: "cmd.exe"
      args: (context) -> ['/q', '/c', context.filepath]

  'Behat Feature':
    "File Based":
      command: "behat"
      args: (context) -> [context.filepath]
    "Line Number Based":
      command: "behat"
      args: (context) -> [context.fileColonLine()]

  BuckleScript:
    "Selection Based":
      command: "bsc"
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        ['-c', tmpFile]
    "File Based":
      command: "bsc"
      args: (context) -> ['-c', context.filepath]

  C:
    "File Based":
      command: "bash"
      args: (context) ->
        args = []
        if GrammarUtils.OperatingSystem.isDarwin()
          args = ['-c', "xcrun clang -fcolor-diagnostics -Wall -include stdio.h '" + context.filepath + "' -o /tmp/c.out && /tmp/c.out"]
        else if GrammarUtils.OperatingSystem.isLinux()
          args = ["-c", "cc -Wall -include stdio.h '" + context.filepath + "' -o /tmp/c.out && /tmp/c.out"]
        return args
    "Selection Based":
      command: "bash"
      args: (context) ->
        code = context.getCode(true)
        tmpFile = GrammarUtils.createTempFileWithCode(code, ".c")
        args = []
        if GrammarUtils.OperatingSystem.isDarwin()
          args = ['-c', "xcrun clang -fcolor-diagnostics -Wall -include stdio.h '" + tmpFile + "' -o /tmp/c.out && /tmp/c.out"]
        else if GrammarUtils.OperatingSystem.isLinux()
          args = ["-c", "cc -Wall -include stdio.h '" + tmpFile + "' -o /tmp/c.out && /tmp/c.out"]
        return args

  'C#':
    "File Based":
      command: if GrammarUtils.OperatingSystem.isWindows() then "cmd" else "bash"
      args: (context) ->
        progname = context.filename.replace /\.cs$/, ""
        args = []
        if GrammarUtils.OperatingSystem.isWindows()
          args = ["/c csc #{context.filepath} && #{progname}.exe"]
        else
          args = ['-c', "csc #{context.filepath} && mono #{progname}.exe"]
        return args
    "Selection Based":
      command: if GrammarUtils.OperatingSystem.isWindows() then "cmd" else "bash"
      args: (context) ->
        code = context.getCode(true)
        tmpFile = GrammarUtils.createTempFileWithCode(code, ".cs")
        progname = tmpFile.replace /\.cs$/, ""
        args = []
        if GrammarUtils.OperatingSystem.isWindows()
          args = ["/c csc /out:#{progname}.exe #{tmpFile} && #{progname}.exe"]
        else
          args = ['-c', "csc /out:#{progname}.exe #{tmpFile} && mono #{progname}.exe"]
        return args

  'C# Script File':
    "File Based":
      command: "scriptcs"
      args: (context) -> ['-script', context.filepath]
    "Selection Based":
      command: "scriptcs"
      args: (context) ->
        code = context.getCode(true)
        tmpFile = GrammarUtils.createTempFileWithCode(code, ".csx")
        ['-script', tmpFile]

  'C++':
    if GrammarUtils.OperatingSystem.isDarwin()
      "Selection Based":
        command: "bash"
        args: (context) ->
          code = context.getCode(true)
          tmpFile = GrammarUtils.createTempFileWithCode(code, ".cpp")
          ["-c", "xcrun clang++ -fcolor-diagnostics -std=c++14 -Wall -include stdio.h -include iostream '" + tmpFile + "' -o /tmp/cpp.out && /tmp/cpp.out"]
      "File Based":
        command: "bash"
        args: (context) -> ['-c', "xcrun clang++ -fcolor-diagnostics -std=c++14 -Wall -include stdio.h -include iostream '" + context.filepath + "' -o /tmp/cpp.out && /tmp/cpp.out"]
    else if GrammarUtils.OperatingSystem.isLinux()
      "Selection Based":
        command: "bash"
        args: (context) ->
          code = context.getCode(true)
          tmpFile = GrammarUtils.createTempFileWithCode(code, ".cpp")
          ["-c", "g++ -std=c++14 -Wall -include stdio.h -include iostream '" + tmpFile + "' -o /tmp/cpp.out && /tmp/cpp.out"]
      "File Based":
        command: "bash"
        args: (context) -> ["-c", "g++ -std=c++14 -Wall -include stdio.h -include iostream '" + context.filepath + "' -o /tmp/cpp.out && /tmp/cpp.out"]
    else if GrammarUtils.OperatingSystem.isWindows() and GrammarUtils.OperatingSystem.release().split(".").slice -1 >= '14399'
      "File Based":
        command: "bash"
        args: (context) -> ["-c", "g++ -std=c++14 -Wall -include stdio.h -include iostream '/mnt/" + path.posix.join.apply(path.posix, [].concat([context.filepath.split(path.win32.sep)[0].toLowerCase()], context.filepath.split(path.win32.sep).slice(1))).replace(":", "") + "' -o /tmp/cpp.out && /tmp/cpp.out"]

  'C++14':
    if GrammarUtils.OperatingSystem.isDarwin()
      "Selection Based":
        command: "bash"
        args: (context) ->
          code = context.getCode(true)
          tmpFile = GrammarUtils.createTempFileWithCode(code, ".cpp")
          ["-c", "xcrun clang++ -fcolor-diagnostics -std=c++14 -Wall -include stdio.h -include iostream '" + tmpFile + "' -o /tmp/cpp.out && /tmp/cpp.out"]
      "File Based":
        command: "bash"
        args: (context) -> ['-c', "xcrun clang++ -fcolor-diagnostics -std=c++14 -Wall -include stdio.h -include iostream '" + context.filepath + "' -o /tmp/cpp.out && /tmp/cpp.out"]
    else if GrammarUtils.OperatingSystem.isLinux()
      "Selection Based":
        command: "bash"
        args: (context) ->
          code = context.getCode(true)
          tmpFile = GrammarUtils.createTempFileWithCode(code, ".cpp")
          ["-c", "g++ -std=c++14 -Wall -include stdio.h -include iostream '" + tmpFile + "' -o /tmp/cpp.out && /tmp/cpp.out"]
      "File Based":
        command: "bash"
        args: (context) -> ["-c", "g++ -std=c++14 -Wall -include stdio.h -include iostream '" + context.filepath + "' -o /tmp/cpp.out && /tmp/cpp.out"]
    else if GrammarUtils.OperatingSystem.isWindows() and GrammarUtils.OperatingSystem.release().split(".").slice -1 >= '14399'
      "File Based":
        command: "bash"
        args: (context) -> ["-c", "g++ -std=c++14 -Wall -include stdio.h -include iostream '/mnt/" + path.posix.join.apply(path.posix, [].concat([context.filepath.split(path.win32.sep)[0].toLowerCase()], context.filepath.split(path.win32.sep).slice(1))).replace(":", "") + "' -o /tmp/cpp.out && /tmp/cpp.out"]

  Clojure:
    "Selection Based":
      command: "lein"
      args: (context)  -> ['exec', '-e', context.getCode()]
    "File Based":
      command: "lein"
      args: (context) -> ['exec', context.filepath]

  CoffeeScript:
    "Selection Based":
      command: "coffee"
      args: (context) -> GrammarUtils.CScompiler.args.concat [context.getCode()]
    "File Based":
      command: "coffee"
      args: (context) -> [context.filepath]

  "CoffeeScript (Literate)":
    'Selection Based':
      command: 'coffee'
      args: (context) -> GrammarUtils.CScompiler.args.concat [context.getCode()]
    'File Based':
      command: 'coffee'
      args: (context) -> [context.filepath]

  "Common Lisp":
    "File Based":
      command: "clisp"
      args: (context) -> [context.filepath]

  Crystal:
    "Selection Based":
      command: "crystal"
      args: (context)  -> ['eval', context.getCode()]
    "File Based":
      command: "crystal"
      args: (context) -> [context.filepath]

  D:
    "Selection Based":
      command: "rdmd"
      args: (context)  ->
        code = context.getCode(true)
        tmpFile = GrammarUtils.D.createTempFileWithCode(code)
        [tmpFile]
    "File Based":
      command: "rdmd"
      args: (context) -> [context.filepath]

  Dart:
    "Selection Based":
      command: "dart"
      args: (context) ->
        code = context.getCode(true)
        tmpFile = GrammarUtils.createTempFileWithCode(code, ".dart")
        [tmpFile]
    "File Based":
      command: "dart"
      args: (context) -> [context.filepath]

  "Graphviz (DOT)":
    "Selection Based":
      command: "dot"
      args: (context) ->
        code = context.getCode(true)
        tmpFile = GrammarUtils.createTempFileWithCode(code, ".dot")
        ['-Tpng', tmpFile, '-o', tmpFile + '.png']
    "File Based":
      command: "dot"
      args: (context) -> ['-Tpng', context.filepath, '-o', context.filepath + '.png']
  DOT:
    "Selection Based":
      command: "dot"
      args: (context) ->
        code = context.getCode(true)
        tmpFile = GrammarUtils.createTempFileWithCode(code, ".dot")
        ['-Tpng', tmpFile, '-o', tmpFile + '.png']
    "File Based":
      command: "dot"
      args: (context) -> ['-Tpng', context.filepath, '-o', context.filepath + '.png']

  Elixir:
    "Selection Based":
      command: "elixir"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "elixir"
      args: (context) -> ['-r', context.filepath]

  Erlang:
    "Selection Based":
      command: "erl"
      args: (context)  -> ['-noshell', '-eval', "#{context.getCode()}, init:stop()."]

  'F#':
    "File Based":
      command: if GrammarUtils.OperatingSystem.isWindows() then "fsi" else "fsharpi"
      args: (context) -> ['--exec', context.filepath]

  'F*':
    "File Based":
      command: "fstar"
      args: (context) -> [context.filepath]

  Fable:
    "Selection Based":
      command: "fable"
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        [tmpFile]
    "File Based":
      command: "fable"
      args: (context) -> [context.filepath]

  Forth:
    "File Based":
      command: "gforth"
      args: (context) -> [context.filepath]

  "Fortran - Fixed Form":
    "File Based":
      command: "bash"
      args: (context) -> ['-c', "gfortran '" + context.filepath + "' -ffixed-form -o /tmp/f.out && /tmp/f.out"]

  "Fortran - Free Form":
    "File Based":
      command: "bash"
      args: (context) -> ['-c', "gfortran '" + context.filepath + "' -ffree-form -o /tmp/f90.out && /tmp/f90.out"]

  "Fortran - Modern":
    "File Based":
      command: "bash"
      args: (context) -> ['-c', "gfortran '" + context.filepath + "' -ffree-form -o /tmp/f90.out && /tmp/f90.out"]

  "Fortran - Punchcard":
    "File Based":
      command: "bash"
      args: (context) -> ['-c', "gfortran '" + context.filepath + "' -ffixed-form -o /tmp/f.out && /tmp/f.out"]

  Gherkin:
    "File Based":
      command: "cucumber"
      args: (context) -> ['--color', context.filepath]
    "Line Number Based":
      command: "cucumber"
      args: (context) -> ['--color', context.fileColonLine()]

  gnuplot:
    "File Based":
      command: "gnuplot"
      args: (context) -> ['-p', context.filepath]
      workingDirectory: atom.workspace.getActivePaneItem()?.buffer?.file?.getParent?().getPath?()

  Go:
    "File Based":
      command: "go"
      args: (context) ->
        if context.filepath.match(/_test.go/) then ['test', '' ]
        else ['run', context.filepath]
      workingDirectory: atom.workspace.getActivePaneItem()?.buffer?.file?.getParent?().getPath?()

  Groovy:
    "Selection Based":
      command: "groovy"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "groovy"
      args: (context) -> [context.filepath]

  Haskell:
    "File Based":
      command: "runhaskell"
      args: (context) -> [context.filepath]
    "Selection Based":
      command: "ghc"
      args: (context)  -> ['-e', context.getCode()]

  Hy:
    "File Based":
      command: "hy"
      args: (context) -> [context.filepath]
    "Selection Based":
      command: "hy"
      args: (context) ->
        code = context.getCode(true)
        tmpFile = GrammarUtils.createTempFileWithCode(code, ".hy")
        [tmpFile]

  IcedCoffeeScript:
    "Selection Based":
      command: "iced"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "iced"
      args: (context) -> [context.filepath]

  Idris:
    "File Based":
      command: "idris"
      args: (context) -> [context.filepath, '-o', path.basename(context.filepath, path.extname(context.filepath))]

  InnoSetup:
    "File Based":
      command: "ISCC.exe"
      args: (context) -> ['/Q', context.filepath]

  ioLanguage:
    "Selection Based":
      command: "io"
      args: (context) -> [context.getCode()]
    "File Based":
      command: "io"
      args: (context) -> ['-e', context.filepath]

  Java:
    "File Based":
      command: if GrammarUtils.OperatingSystem.isWindows() then "cmd" else "bash"
      args: (context) ->
        className = GrammarUtils.Java.getClassName context
        classPackages = GrammarUtils.Java.getClassPackage context
        sourcePath = GrammarUtils.Java.getProjectPath context

        args = []
        if GrammarUtils.OperatingSystem.isWindows()
          args = ["/c javac -Xlint #{context.filename} && java #{className}"]
        else
          args = ['-c', "javac -sourcepath #{sourcePath} -d /tmp '#{context.filepath}' && java -cp /tmp #{classPackages}#{className}"]

        return args

  JavaScript:
    "Selection Based":
      command: "node"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "node"
      args: (context) -> [context.filepath]

  'JavaScript with JSX':
    "Selection Based":
      command: "node"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "node"
      args: (context) -> [context.filepath]

  "JavaScript for Automation (JXA)":
    "Selection Based":
      command: "osascript"
      args: (context)  -> ['-l', 'JavaScript', '-e', context.getCode()]
    "File Based":
      command: "osascript"
      args: (context) -> ['-l', 'JavaScript', context.filepath]

  Jolie:
    "File Based":
      command: "jolie"
      args: (context) -> [context.filepath]

  Julia:
    "Selection Based":
      command: "julia"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "julia"
      args: (context) -> [context.filepath]

  Kotlin:
    "Selection Based":
      command: "bash"
      args: (context) ->
        code = context.getCode(true)
        tmpFile = GrammarUtils.createTempFileWithCode(code, ".kt")
        jarName = tmpFile.replace /\.kt$/, ".jar"
        args = ['-c', "kotlinc #{tmpFile} -include-runtime -d #{jarName} && java -jar #{jarName}"]
        return args
    "File Based":
      command: "bash"
      args: (context) ->
        jarName = context.filename.replace /\.kt$/, ".jar"
        args = ['-c', "kotlinc #{context.filepath} -include-runtime -d /tmp/#{jarName} && java -jar /tmp/#{jarName}"]
        return args

  LAMMPS:
    if GrammarUtils.OperatingSystem.isDarwin() || GrammarUtils.OperatingSystem.isLinux()
      "File Based":
        command: "lammps"
        args: (context) -> ['-log', 'none', '-in', context.filepath]

  LaTeX:
    "File Based":
      command: "latexmk"
      args: (context) -> ['-cd', '-quiet', '-pdf', '-pv', '-shell-escape', context.filepath]

  'LaTeX Beamer':
    "File Based":
      command: "latexmk"
      args: (context) -> ['-cd', '-quiet', '-pdf', '-pv', '-shell-escape', context.filepath]

  LilyPond:
    "File Based":
      command: "lilypond"
      args: (context) -> [context.filepath]

  Lisp:
    "Selection Based":
      command: "sbcl"
      args: (context) ->
        statements = _.flatten(_.map(GrammarUtils.Lisp.splitStatements(context.getCode()), (statement) -> ['--eval', statement]))
        args = _.union ['--noinform', '--disable-debugger', '--non-interactive', '--quit'], statements
        return args
    "File Based":
      command: "sbcl"
      args: (context) -> ['--noinform', '--script', context.filepath]

  'Literate Haskell':
    "File Based":
      command: "runhaskell"
      args: (context) -> [context.filepath]

  LiveScript:
    "Selection Based":
      command: "lsc"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "lsc"
      args: (context) -> [context.filepath]

  Lua:
    "Selection Based":
      command: "lua"
      args: (context) ->
        code = context.getCode(true)
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        [tmpFile]
    "File Based":
      command: "lua"
      args: (context) -> [context.filepath]

  'Lua (WoW)':
    "Selection Based":
      command: "lua"
      args: (context) ->
        code = context.getCode(true)
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        [tmpFile]
    "File Based":
      command: "lua"
      args: (context) -> [context.filepath]

  Makefile:
    "Selection Based":
      command: "bash"
      args: (context) -> ['-c', context.getCode()]
    "File Based":
      command: "make"
      args: (context) -> ['-f', context.filepath]

  MagicPython:
    "Selection Based":
      command: "python"
      args: (context)  -> ['-u', '-c', context.getCode()]
    "File Based":
      command: "python"
      args: (context) -> ['-u', context.filepath]

  MATLAB:
    "Selection Based":
      command: "matlab"
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.MATLAB.createTempFileWithCode(code)
        ['-nodesktop','-nosplash','-r',"try, run('" + tmpFile + "');while ~isempty(get(0,'Children')); pause(0.5); end; catch ME; disp(ME.message); exit(1); end; exit(0);"]
    "File Based":
      command: "matlab"
      args: (context) -> ['-nodesktop','-nosplash','-r',"try run('" + context.filepath + "');while ~isempty(get(0,'Children')); pause(0.5); end; catch ME; disp(ME.message); exit(1); end; exit(0);"]

  'MIPS Assembler':
    "File Based":
      command: "spim"
      args: (context) -> ['-f', context.filepath]

  MoonScript:
    "Selection Based":
      command: "moon"
      args: (context) -> ['-e', context.getCode()]
    "File Based":
      command: "moon"
      args: (context) -> [context.filepath]

  'mongoDB (JavaScript)':
    "Selection Based":
      command: "mongo"
      args: (context) -> ['--eval', context.getCode()]
    "File Based":
      command:  "mongo"
      args: (context) -> [context.filepath]

  NCL:
    "Selection Based":
      command: "ncl"
      args: (context) ->
        code = context.getCode(true)
        code = code + """

        exit"""
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        [tmpFile]
    "File Based":
      command: "ncl"
      args: (context) -> [context.filepath]

  newLISP:
    "Selection Based":
      command: "newlisp"
      args: (context) -> ['-e', context.getCode()]
    "File Based":
      command: "newlisp"
      args: (context) -> [context.filepath]

  Nim:
    "File Based":
      command: "bash"
      args: (context) ->
        file = GrammarUtils.Nim.findNimProjectFile(context.filepath)
        path = GrammarUtils.Nim.projectDir(context.filepath)
        ['-c', 'cd "' + path + '" && nim c --hints:off --parallelBuild:1 -r "' + file + '" 2>&1']

  NSIS:
    "Selection Based":
      command: "makensis"
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        [tmpFile]
    "File Based":
      command: "makensis"
      args: (context) -> [context.filepath]

  'Objective-C':
    if GrammarUtils.OperatingSystem.isDarwin()
      "File Based":
        command: "bash"
        args: (context) -> ['-c', "xcrun clang -fcolor-diagnostics -Wall -include stdio.h -framework Cocoa " + context.filepath + " -o /tmp/objc-c.out && /tmp/objc-c.out"]

  'Objective-C++':
    if GrammarUtils.OperatingSystem.isDarwin()
      "File Based":
        command: "bash"
        args: (context) -> ['-c', "xcrun clang++ -fcolor-diagnostics -Wc++11-extensions -Wall -include stdio.h -include iostream -framework Cocoa " + context.filepath + " -o /tmp/objc-cpp.out && /tmp/objc-cpp.out"]

  OCaml:
    "File Based":
      command: "ocaml"
      args: (context) -> [context.filepath]

  Octave:
    "Selection Based":
      command: "octave"
      args: (context) -> ['-p', context.filepath.replace(/[^\/]*$/, ''), '--eval', context.getCode()]
    "File Based":
      command: "octave"
      args: (context) -> ['-p', context.filepath.replace(/[^\/]*$/, ''), context.filepath]

  Oz:
    "Selection Based":
      command: "ozc"
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        ['-c', tmpFile]
    "File Based":
      command: "ozc"
      args: (context) -> ['-c', context.filepath]

  'Pandoc Markdown':
    "File Based":
      command: "panzer"
      args: (context) -> [context.filepath, "--output=" + context.filepath + ".pdf"]

  Perl:
    "Selection Based":
      command: "perl"
      args: (context) ->
        code = context.getCode()
        file = GrammarUtils.Perl.createTempFileWithCode(code)
        [file]
    "File Based":
      command: "perl"
      args: (context) -> [context.filepath]

  "Perl 6":
    "Selection Based":
      command: "perl6"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "perl6"
      args: (context) -> [context.filepath]

  "Perl 6 FE":
    "Selection Based":
      command: "perl6"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "perl6"
      args: (context) -> [context.filepath]

  PHP:
    "Selection Based":
      command: "php"
      args: (context) ->
        code = context.getCode()
        file = GrammarUtils.PHP.createTempFileWithCode(code)
        [file]
    "File Based":
      command: "php"
      args: (context) -> [context.filepath]

  PowerShell:
    "Selection Based":
      command: "powershell"
      args: (context) -> [context.getCode()]
    "File Based":
      command: "powershell"
      args: (context) -> [context.filepath.replace /\ /g, "` "]

  Processing:
    "File Based":
      command: if GrammarUtils.OperatingSystem.isWindows() then "cmd" else "bash"
      args: (context) ->
        if GrammarUtils.OperatingSystem.isWindows()
          return ['/c processing-java --sketch='+context.filepath.replace("\\"+context.filename,"")+' --run']
        else
          return ['-c', 'processing-java --sketch='+context.filepath.replace("/"+context.filename,"")+' --run']


  Prolog:
    "File Based":
      command: "bash"
      args: (context) -> ['-c', 'cd \"' + context.filepath.replace(/[^\/]*$/, '') + '\"; swipl -f \"' + context.filepath + '\" -t main --quiet']

  PureScript:
    "File Based":
      command: if GrammarUtils.OperatingSystem.isWindows() then "cmd" else "bash"
      args: (context) ->
        if GrammarUtils.OperatingSystem.isWindows()
          ['/c cd "' + context.filepath.replace(/[^\/]*$/, '') + '" && pulp run']
        else
          ['-c', 'cd "' + context.filepath.replace(/[^\/]*$/, '') + '" && pulp run']

  Python:
    "Selection Based":
      command: "python"
      args: (context)  -> ['-u', '-c', context.getCode()]
    "File Based":
      command: "python"
      args: (context) -> ['-u', context.filepath]

  R:
    "Selection Based":
      command: "Rscript"
      args: (context) ->
        code = context.getCode()
        file = GrammarUtils.R.createTempFileWithCode(code)
        [file]
    "File Based":
      command: "Rscript"
      args: (context) -> [context.filepath]

  Racket:
    "Selection Based":
      command: "racket"
      args: (context) -> ['-e', context.getCode()]
    "File Based":
      command: "racket"
      args: (context) -> [context.filepath]

  RANT:
    "Selection Based":
      command: "RantConsole.exe"
      args: (context) ->
        code = context.getCode(true)
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        ['-file', tmpFile]
    "File Based":
      command: "RantConsole.exe"
      args: (context) -> ['-file', context.filepath]

  Reason:
    "File Based":
      command: if GrammarUtils.OperatingSystem.isWindows() then "cmd" else "bash"
      args: (context) ->
        progname = context.filename.replace /\.re$/, ""
        args = []
        if GrammarUtils.OperatingSystem.isWindows()
          args = ["/c rebuild #{progname}.native && #{progname}.native"]
        else
          args = ['-c', "rebuild '#{progname}.native' && '#{progname}.native'"]
        return args

  "Ren'Py":
    "File Based":
      command: "renpy"
      args: (context) -> [context.filepath.substr(0, context.filepath.lastIndexOf("/game"))]

  'Robot Framework':
    "File Based":
      command: 'robot'
      args: (context) -> [context.filepath]

  RSpec:
    "Selection Based":
      command: "ruby"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "rspec"
      args: (context) -> ['--tty', '--color', context.filepath]
    "Line Number Based":
      command: "rspec"
      args: (context) -> ['--tty', '--color', context.fileColonLine()]

  Ruby:
    "Selection Based":
      command: "ruby"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "ruby"
      args: (context) -> [context.filepath]

  'Ruby on Rails':
    "Selection Based":
      command: "rails"
      args: (context)  -> ['runner', context.getCode()]
    "File Based":
      command: "rails"
      args: (context) -> ['runner', context.filepath]

  Rust:
    "File Based":
      command: if GrammarUtils.OperatingSystem.isWindows() then "cmd" else "bash"
      args: (context) ->
        progname = context.filename.replace /\.rs$/, ""
        args = []
        if GrammarUtils.OperatingSystem.isWindows()
          args = ["/c rustc #{context.filepath} && #{progname}.exe"]
        else
          args = ['-c', "rustc '#{context.filepath}' -o /tmp/rs.out && /tmp/rs.out"]
        return args

  Sage:
    "Selection Based":
      command: "sage"
      args: (context) -> ['-c', context.getCode()]
    "File Based":
      command: "sage"
      args: (context) -> [context.filepath]

  Sass:
    "File Based":
      command: "sass"
      args: (context) -> [context.filepath]

  Scala:
    "Selection Based":
      command: "scala"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "scala"
      args: (context) -> [context.filepath]

  Scheme:
    "Selection Based":
      command: "guile"
      args: (context)  -> ['-c', context.getCode()]
    "File Based":
      command: "guile"
      args: (context) -> [context.filepath]

  SCSS:
    "File Based":
      command: "sass"
      args: (context) -> [context.filepath]

  "Shell Script":
    "Selection Based":
      command: process.env.SHELL
      args: (context)  -> ['-c', context.getCode()]
    "File Based":
      command: process.env.SHELL
      args: (context) -> [context.filepath]

  "Shell Script (Fish)":
    "Selection Based":
      command: "fish"
      args: (context)  -> ['-c', context.getCode()]
    "File Based":
      command: "fish"
      args: (context) -> [context.filepath]

  "SQL":
    "Selection Based":
      command: "echo"
      args: (context) -> ['SQL requires setting \'Script: Run Options\' directly. See https://github.com/rgbkrk/atom-script/tree/master/examples/hello.sql for further information.']
    "File Based":
      command: "echo"
      args: (context) -> ['SQL requires setting \'Script: Run Options\' directly. See https://github.com/rgbkrk/atom-script/tree/master/examples/hello.sql for further information.']

  "SQL (PostgreSQL)":
    "Selection Based":
      command: "psql"
      args: (context) -> ['-c', context.getCode()]
    "File Based":
      command: "psql"
      args: (context) -> ['-f', context.filepath]

  "Standard ML":
    "File Based":
      command: "sml"
      args: (context) -> [context.filepath]

  Stata:
    "Selection Based":
      command: "stata"
      args: (context)  -> ['do', context.getCode()]
    "File Based":
      command: "stata"
      args: (context) -> ['do', context.filepath]

  Swift:
    "File Based":
      command: "swift"
      args: (context) -> [context.filepath]

  Tcl:
    "Selection Based":
      command: "tclsh"
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code)
        [tmpFile]
    "File Based":
      command: "tclsh"
      args: (context) -> [context.filepath]

  Turing:
    "File Based":
      command: "turing"
      args: (context) -> ['-run', context.filepath]

  TypeScript:
    "Selection Based":
      command: "ts-node"
      args: (context) -> ['-e', context.getCode()]
    "File Based":
      command: "ts-node"
      args: (context) -> [context.filepath]

  VBScript:
    'Selection Based':
      command: 'cscript'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code, ".vbs")
        ['//NOLOGO',tmpFile]
    'File Based':
      command: 'cscript'
      args: (context) -> ['//NOLOGO', context.filepath]

  HTML:
    "File Based":
      command: 'echo'
      args: (context) ->
        uri = 'file://' + context.filepath
        shell.openExternal(uri)
        ['HTML file opened at:', uri]
