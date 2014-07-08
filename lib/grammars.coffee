# Maps Atom Grammar names to the command used by that language
# As well as any special setup for arguments.

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
      args: (context) -> ['--ansi', context.filepath]
    "Line Based":
      command: "behat"
      args: (context) -> ['--ansi', context.fileColonLine()]

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
      command: "fsharpi"
      args: (context) -> ['--exec', context.filepath]

  Gherkin:
    "File Based":
      command: "cucumber"
      args: (context) -> ['--color', context.filepath]
    "Line Based":
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

  JavaScript:
    "Selection Based":
      command: "node"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "node"
      args: (context) -> [context.filepath]

  Julia:
    "Selection Based":
      command: "julia"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "julia"
      args: (context) -> [context.filepath]

  LiveScript:
    "Selection Based":
      command: "livescript"
      args: (code)  -> ['-e', code]
    "File Based":
      command: "livescript"
      args: (filename) -> [filename]

  Lua:
    "Selection Based":
      command: "lua"
      args: (context)  -> ['-e', context.getCode()]
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

  newLISP:
    "Selection Based":
      command: "newlisp"
      args: (context) -> ['-e', context.getCode()]
    "File Based":
      command: "newlisp"
      args: (context) -> [context.filepath]

  PHP:
    "Selection Based":
      command: "php"
      args: (context)  -> ['-r', context.getCode()]
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

  RSpec:
    "Selection Based":
      command: "ruby"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "rspec"
      args: (context) -> ['--tty', '--color', context.filepath]
    "Line Based":
      command: "rspec"
      args: (context) -> ['--tty', '--color', context.fileColonLine()]

  Ruby:
    "Selection Based":
      command: "ruby"
      args: (context)  -> ['-e', context.getCode()]
    "File Based":
      command: "ruby"
      args: (context) -> [context.filepath]

  'Shell Script (Bash)':
    "Selection Based":
      command: "bash"
      args: (context)  -> ['-c', context.getCode()]
    "File Based":
      command: "bash"
      args: (context) -> [context.filepath]

  Rust:
    "File Based":
      command: "rustc"
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
