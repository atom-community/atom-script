# Maps Atom Grammar names to the command used by that language
# As well as any special setup for arguments.

_ = require 'underscore'
GrammarUtils = require '../lib/grammar-utils'

module.exports =
  AppleScript:
    'Selection Based':
      command: 'osascript'
      args: (context)  -> ['-e', context.getCode()]
    'File Based':
      command: 'osascript'
      args: (context) -> [context.filepath]

  'Behat Feature':
    "File Based":
      command: "behat"
      args: (context) -> [context.filepath]
    "Line Number Based":
      command: "behat"
      args: (context) -> [context.fileColonLine()]

  Batch:
    "File Based":
      command: ""
      args: (context) -> [context.filepath]
  C:
    if GrammarUtils.OperatingSystem.isDarwin()
      "File Based":
        command: "bash"
        args: (context) -> ['-c', "xcrun clang -fcolor-diagnostics -Wall -include stdio.h '" + context.filepath + "' -o /tmp/c.out && /tmp/c.out"]
    else if GrammarUtils.OperatingSystem.isLinux()
      "File Based":
        command: "bash"
        args: (context) -> ["-c", "cc -Wall -include stdio.h '" + context.filepath + "' -o /tmp/c.out && /tmp/c.out"]

  'C++':
    if GrammarUtils.OperatingSystem.isDarwin()
      "File Based":
        command: "bash"
        args: (context) -> ['-c', "xcrun clang++ -fcolor-diagnostics -Wc++11-extensions -Wall -include stdio.h -include iostream '" + context.filepath + "' -o /tmp/cpp.out && /tmp/cpp.out"]

  'C# Script File':
    "File Based":
      command: "scriptcs"
      args: (context) -> ['-script', context.filepath]

  CoffeeScript:
    "Selection Based":
      command: "coffee"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "coffee"
      args: (context) -> [context.filepath]

  'CoffeeScript (Literate)':
    "Selection Based":
      command: "coffee"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "coffee"
      args: (context) -> [context.filepath]

  Crystal:
    "Selection Based":
      command: "crystal"
      args: (context)  -> ['eval', context.getCode()]
    "File Based":
      command: "crystal"
      args: (context) -> [context.filepath]

  D:
    "File Based":
      command: "rdmd"
      args: (context) -> [context.filepath]

  DOT:
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

  Forth:
    "File Based":
      command: "gforth"
      args: (context) -> [context.filepath]

  Gherkin:
    "File Based":
      command: "cucumber"
      args: (context) -> ['--color', context.filepath]
    "Line Number Based":
      command: "cucumber"
      args: (context) -> ['--color', context.fileColonLine()]

  Go:
    "File Based":
      command: "go"
      args: (context) -> ['run', context.filepath]

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

  IcedCoffeeScript:
    "Selection Based":
      command: "iced"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "iced"
      args: (context) -> [context.filepath]

  Java:
    "File Based":
      command: "bash"
      args: (context) ->
        className = context.filename.replace /\.java$/, ""
        args = ['-c', "javac -d /tmp '#{context.filepath}' && java -cp /tmp #{className}"]
        return args

  JavaScript:
    "Selection Based":
      command: "node"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "node"
      args: (context) -> [context.filepath]

  'Babel ES6 JavaScript':
    "Selection Based":
      command: "babel-node"
      args: (context) -> ['-e', context.getCode()]
    "File Based":
      command: "babel-node"
      args: (context) -> [context.filepath]

  "JavaScript for Automation":
    "Selection Based":
      command: "osascript"
      args: (context)  -> ['-l', 'JavaScript', '-e', context.getCode()]
    "File Based":
      command: "osascript"
      args: (context) -> ['-l', 'JavaScript', context.filepath]

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

  LaTeX:
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

  ocaml:
    "File Based":
      command: "ocaml"
      args: (context) -> [context.filepath]

  'Pandoc Markdown':
    "File Based":
      command: "panzer"
      args: (context) -> [context.filepath, "--output=" + context.filepath + ".pdf"]

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

  Perl:
    "Selection Based":
      command: "perl"
      args: (context)  -> ['-e', context.getCode()]
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

  PowerShell:
    "File Based":
      command: "powershell"
      args: (context) -> [context.filepath.replace /\ /g, "` "]

  Python:
    "Selection Based":
      command: "python"
      args: (context)  -> ['-c', context.getCode()]
    "File Based":
      command: "python"
      args: (context) -> [context.filepath]

  R:
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
      command: "bash"
      args: (context) -> ['-c', "rustc " + context.filepath + " -o /tmp/rs.out && /tmp/rs.out"]

  Makefile:
    "Selection Based":
      command: "bash"
      args: (context) -> ['-c', context.getCode()]
    "File Based":
      command: "make"
      args: (context) -> ['-f', context.filepath]

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
      command: "bash"
      args: (context)  -> ['-c', context.getCode()]
    "File Based":
      command: "bash"
      args: (context) -> [context.filepath]

  "Shell Script (Fish)":
    "Selection Based":
      command: "fish"
      args: (context)  -> ['-c', context.getCode()]
    "File Based":
      command: "fish"
      args: (context) -> [context.filepath]

  "Standard ML":
    "File Based":
      command: "sml"
      args: (context) -> [context.filepath]

  Nim:
    "File Based":
      command: "bash"
      args: (context) ->
        file = GrammarUtils.Nim.findNimProjectFile(context.filepath)
        path = GrammarUtils.Nim.projectDir(context.filepath)
        ['-c', 'cd "' + path + '" && nim c --colors:on --hints:off --parallelBuild:1 -r "' + file + '" 2>&1']

  Swift:
    "File Based":
      command: "xcrun"
      args: (context) -> ['swift', context.filepath]

  TypeScript:
    "Selection Based":
      command: "bash"
      args: (context) ->
        code = context.getCode(true)
        tmpFile = GrammarUtils.createTempFileWithCode(code, ".ts")
        jsFile = tmpFile.replace /\.ts$/, ".js"
        args = ['-c', "tsc --out '#{jsFile}' '#{tmpFile}' && node '#{jsFile}'"]
        return args
    "File Based":
      command: "bash"
      args: (context) -> ['-c', "tsc '#{context.filepath}' --out /tmp/js.out && node /tmp/js.out"]

  Dart:
    "File Based":
      command: "dart"
      args: (context) -> [context.filepath]
