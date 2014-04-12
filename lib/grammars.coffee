# Maps Atom Grammar names to the command used by that language
# As well as any special setup for arguments.

module.exports =
  CoffeeScript:
    command: "coffee"
    "Selection Based": (code) -> ['-e', code]
    "File Based": (filename) -> [filename]

  'CoffeeScript (Literate)':
    command: "coffee"
    "Selection Based": (code) -> ['-e', code]
    "File Based": (filename) -> [filename]

  Elixir:
    command: "elixir"
    "Selection Based": (code) -> ['-e', code]
    "File Based": (filename) -> ['-r', filename]

  Erlang:
    command: "erl"
    "Selection Based": (code) -> ['-noshell', '-eval', code+', init:stop().']

  'F#':
    command: "fsharpi"
    "File Based": (filename) -> ['--exec', filename]

  Go:
    command: "go"
    #"Selection Based": (code) -> []
    "File Based": (filename) -> ['run', filename]

  Groovy:
    command: "groovy"
    "Selection Based": (code) -> ['-e', code]
    "File Based": (filename) -> [filename]

  Haskell:
    command: "runhaskell"
    "File Based": (filename) -> [filename]
    #command: "ghc"
    #"Selection Based": (code) -> ['-e', code]

  JavaScript:
    command: "node"
    "Selection Based": (code) -> ['-e', code]
    "File Based": (filename) -> [filename]

  Julia:
    command: "julia"
    "Selection Based": (code) -> ['-e', code]
    "File Based": (filename) -> [filename]

  Lua:
    command: "lua"
    "Selection Based": (code) -> ['-e', code]
    "File Based": (filename) -> [filename]

  PHP:
    command: "php"
    "Selection Based": (code) -> ['-r', code]

  Perl:
    command: "perl"
    "Selection Based": (code) -> ['-e', code]
    "File Based": (filename) -> [filename]

  Python:
    command: "python"
    "Selection Based": (code) -> ['-c', code]

  RSpec:
    command: "rspec"
    #"Selection Based": (code) -> []
    "File Based": (filename) -> [filename]

  Ruby:
    command: "ruby"
    "Selection Based": (code) -> ['-e', code]
    "File Based": (filename) -> [filename]

  'Shell Script (Bash)':
    command: "bash"
    "Selection Based": (code) -> ['-c', code]

  Scala:
    command: "scala"
    "Selection Based": (code) -> ['-e', code]
    "File Based": (filename) -> [filename]

  newLISP:
    command: "newlisp"
    "Selection Based": (code) -> ['-e', code]
    "File Based": (filename) -> [filename]

  Gherkin:
    command: "cucumber"
    #"Selection Based": (code) -> ['-e', code]
    "File Based": (filename) -> [filename]
