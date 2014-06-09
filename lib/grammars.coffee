# Maps Atom Grammar names to the command used by that language
# As well as any special setup for arguments.

module.exports =
  AppleScript:
    'Selection Based':
      command: 'osascript'
      args: (code)  -> ['-e', code]
    'File Based':
      command: 'osascript'
      args: (filename) -> [filename]

  'Behat Feature':
    "File Based":
      command: "behat"
      args: (filename) -> ['--ansi', filename]

  CoffeeScript:
    "Selection Based":
      command: "coffee"
      args: (code)  -> ['-e', code]
    "File Based":
      command: "coffee"
      args: (filename) -> [filename]

  'CoffeeScript (Literate)':
    "Selection Based":
      command: "coffee"
      args: (code)  -> ['-e', code]
    "File Based":
      command: "coffee"
      args: (filename) -> [filename]

  Elixir:
    "Selection Based":
      command: "elixir"
      args: (code)  -> ['-e', code]
    "File Based":
      command: "elixir"
      args: (filename) -> ['-r', filename]

  Erlang:
    "Selection Based":
      command: "erl"
      args: (code)  -> ['-noshell', '-eval', code+', init:stop().']

  'F#':
    "File Based":
      command: "fsharpi"
      args: (filename) -> ['--exec', filename]

  Gherkin:
    "File Based":
      command: "cucumber"
      args: (filename) -> ['--color', filename]

  Go:
    "File Based":
      command: "go"
      args: (filename) -> ['run', filename]

  Groovy:
    "Selection Based":
      command: "groovy"
      args: (code)  -> ['-e', code]
    "File Based":
      command: "groovy"
      args: (filename) -> [filename]

  Haskell:
    "File Based":
      command: "runhaskell"
      args: (filename) -> [filename]
    "Selection Based":
      command: "ghc"
      args: (code)  -> ['-e', code]

  IcedCoffeeScript:
    "Selection Based":
      command: "iced"
      args: (code)  -> ['-e', code]
    "File Based":
      command: "iced"
      args: (filename) -> [filename]

  JavaScript:
    "Selection Based":
      command: "node"
      args: (code)  -> ['-e', code]
    "File Based":
      command: "node"
      args: (filename) -> [filename]

  Julia:
    "Selection Based":
      command: "julia"
      args: (code)  -> ['-e', code]
    "File Based":
      command: "julia"
      args: (filename) -> [filename]

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
      args: (code)  -> ['-e', code]
    "File Based":
      command: "lua"
      args: (filename) -> [filename]

  newLISP:
    "Selection Based":
      command: "newlisp"
      args: (code) -> ['-e', code]
    "File Based":
      command: "newlisp"
      args: (filename) -> [filename]

  PHP:
    "Selection Based":
      command: "php"
      args: (code)  -> ['-r', code]
    "File Based":
      command: "php"
      args: (filename) -> [filename]

  Perl:
    "Selection Based":
      command: "perl"
      args: (code)  -> ['-e', code]
    "File Based":
      command: "perl"
      args: (filename) -> [filename]

  Python:
    "Selection Based":
      command: "python"
      args: (code)  -> ['-c', code]
    "File Based":
      command: "python"
      args: (filename) -> [filename]

  R:
    "File Based":
      command: "Rscript"
      args: (filename) -> [filename]

  RSpec:
    "Selection Based":
      command: "ruby"
      args: (code)  -> ['-e', code]
    "File Based":
      command: "rspec"
      args: (filename) -> ['--tty', '--color', filename]

  Ruby:
    "Selection Based":
      command: "ruby"
      args: (code)  -> ['-e', code]
    "File Based":
      command: "ruby"
      args: (filename) -> [filename]

  'Shell Script (Bash)':
    "Selection Based":
      command: "bash"
      args: (code)  -> ['-c', code]
    "File Based":
      command: "bash"
      args: (filename) -> [filename]

  Scala:
    "Selection Based":
      command: "scala"
      args: (code)  -> ['-e', code]
    "File Based":
      command: "scala"
      args: (filename) -> [filename]

  Scheme:
    "Selection Based":
      command: "guile"
      args: (code)  -> ['-c', code]
    "File Based":
      command: "guile"
      args: (filename) -> [filename]
