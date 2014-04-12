# Maps Atom Grammar names to the command used by that language
# As well as any special setup for arguments.

module.exports =
  CoffeeScript:
    command: "coffee"
    "Selection Based":
      args: (code)  -> ['-e', code]
    "File Based":
      args: (filename) -> [filename]

  'CoffeeScript (Literate)':
    command: "coffee"
    "Selection Based":
      args: (code)  -> ['-e', code]
    "File Based":
      args: (filename) -> [filename]

  Elixir:
    command: "elixir"
    "Selection Based":
      args: (code)  -> ['-e', code]
    "File Based":
      args: (filename) -> ['-r', filename]

  Erlang:
    command: "erl"
    "Selection Based":
      args: (code)  -> ['-noshell', '-eval', code+', init:stop().']

  'F#':
    command: "fsharpi"
    "File Based":
      args: (filename) -> ['--exec', filename]

  Gherkin:
    command: "cucumber"
    "File Based":
      args: (filename) -> [filename]

  Go:
    command: "go"
    "File Based":
      args: (filename) -> ['run', filename]

  Groovy:
    command: "groovy"
    "Selection Based":
      args: (code)  -> ['-e', code]
    "File Based":
      args: (filename) -> [filename]

  Haskell:
    "File Based":
      command: "runhaskell"
      args: (filename) -> [filename]
    "Selection Based":
      command: "ghc"
      args: (code)  -> ['-e', code]

  JavaScript:
    command: "node"
    "Selection Based":
      args: (code)  -> ['-e', code]
    "File Based":
      args: (filename) -> [filename]

  Julia:
    command: "julia"
    "Selection Based":
      args: (code)  -> ['-e', code]
    "File Based":
      args: (filename) -> [filename]

  Lua:
    command: "lua"
    "Selection Based":
      args: (code)  -> ['-e', code]
    "File Based":
      args: (filename) -> [filename]

  PHP:
    command: "php"
    "Selection Based":
      args: (code)  -> ['-r', code]

  Perl:
    command: "perl"
    "Selection Based":
      args: (code)  -> ['-e', code]
    "File Based":
      args: (filename) -> [filename]

  Python:
    command: "python"
    "Selection Based":
      args: (code)  -> ['-c', code]
    "File Based":
      args: (filename) -> [filename]

  RSpec:
    command: "rspec"
    "Selection Based":
      command: "ruby"
      args: (code)  -> ['-e', code]
    "File Based":
      args: (filename) -> [filename]

  Ruby:
    command: "ruby"
    "Selection Based":
      args: (code)  -> ['-e', code]
    "File Based":
      args: (filename) -> [filename]

  'Shell Script (Bash)':
    command: "bash"
    "Selection Based":
      args: (code)  -> ['-c', code]
    "File Based":
      args: (filename) -> [filename]

  Scala:
    command: "scala"
    "Selection Based":
      args: (code)  -> ['-e', code]
    "File Based":
      args: (filename) -> [filename]

  newLISP:
    command: "newlisp"
    "Selection Based":
      args: (code)  -> ['-e', code]
    "File Based":
      args: (filename) -> [filename]
