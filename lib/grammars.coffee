# Maps Atom Grammar names to the command used by that language
# As well as any special setup for arguments.

module.exports =
  'Behat Feature':
    "Selection Based":
      command: "behat"
      args: (filename, selection) ->
        buffer_row_range = selection.getBufferRowRange()
        line_number = buffer_row_range.reduce (a,b) -> Math.min(a, b)
        line_number += 1
        ["#{filename}:#{line_number}"]
    "File Based":
      command: "behat"
      args: (filename) -> [filename]

  CoffeeScript:
    "Selection Based":
      command: "coffee"
      args: (filename, selection) -> ['-e', selection.getText()]
    "File Based":
      command: "coffee"
      args: (filename) -> [filename]

  'CoffeeScript (Literate)':
    "Selection Based":
      command: "coffee"
      args: (filename, selection) -> ['-e', selection.getText()]
    "File Based":
      command: "coffee"
      args: (filename) -> [filename]

  Elixir:
    "Selection Based":
      command: "elixir"
      args: (filename, selection) -> ['-e', selection.getText()]
    "File Based":
      command: "elixir"
      args: (filename) -> ['-r', filename]

  Erlang:
    "Selection Based":
      command: "erl"
      args: (filename, selection) -> ['-noshell', '-eval', selection.getText()+', init:stop().']

  'F#':
    "File Based":
      command: "fsharpi"
      args: (filename) -> ['--exec', filename]

  Gherkin:
    "Selection Based":
      command: "cucumber"
      args: (filename, selection) ->
        buffer_row_range = selection.getBufferRowRange()
        line_number = buffer_row_range.reduce (a,b) -> Math.min(a, b)
        line_number += 1
        ["#{filename}:#{line_number}"]
    "File Based":
      command: "cucumber"
      args: (filename) -> [filename]

  Go:
    "File Based":
      command: "go"
      args: (filename) -> ['run', filename]

  Groovy:
    "Selection Based":
      command: "groovy"
      args: (filename, selection) -> ['-e', selection.getText()]
    "File Based":
      command: "groovy"
      args: (filename) -> [filename]

  Haskell:
    "File Based":
      command: "runhaskell"
      args: (filename) -> [filename]
    "Selection Based":
      command: "ghc"
      args: (filename, selection) -> ['-e', selection.getText()]

  JavaScript:
    "Selection Based":
      command: "node"
      args: (filename, selection) -> ['-e', selection.getText()]
    "File Based":
      command: "node"
      args: (filename) -> [filename]

  Julia:
    "Selection Based":
      command: "julia"
      args: (filename, selection) -> ['-e', selection.getText()]
    "File Based":
      command: "julia"
      args: (filename) -> [filename]

  Lua:
    "Selection Based":
      command: "lua"
      args: (filename, selection) -> ['-e', selection.getText()]
    "File Based":
      command: "lua"
      args: (filename) -> [filename]

  newLISP:
    "Selection Based":
      command: "newlisp"
      args: (filename, selection) -> ['-e', selection.getText()]
    "File Based":
      command: "newlisp"
      args: (filename) -> [filename]

  PHP:
    "Selection Based":
      command: "php"
      args: (filename, selection) -> ['-r', selection.getText()]
    "File Based":
      command: "php"
      args: (filename) -> [filename]

  Perl:
    "Selection Based":
      command: "perl"
      args: (filename, selection) -> ['-e', selection.getText()]
    "File Based":
      command: "perl"
      args: (filename) -> [filename]

  Python:
    "Selection Based":
      command: "python"
      args: (filename, selection) -> ['-c', selection.getText()]
    "File Based":
      command: "python"
      args: (filename) -> [filename]

  RSpec:
    "Selection Based":
      command: "ruby"
      args: (filename, selection) -> ['-e', selection.getText()]
    "File Based":
      command: "rspec"
      args: (filename) -> [filename]

  Ruby:
    "Selection Based":
      command: "ruby"
      args: (filename, selection) -> ['-e', selection.getText()]
    "File Based":
      command: "ruby"
      args: (filename) -> [filename]

  'Shell Script (Bash)':
    "Selection Based":
      command: "bash"
      args: (filename, selection) -> ['-c', selection.getText()]
    "File Based":
      command: "bash"
      args: (filename) -> [filename]

  Scala:
    "Selection Based":
      command: "scala"
      args: (filename, selection) -> ['-e', selection.getText()]
    "File Based":
      command: "scala"
      args: (filename) -> [filename]
