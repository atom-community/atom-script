# Maps Atom Grammar names to the command used by that language
# As well as any special setup for arguments.

module.exports =
  CoffeeScript:
    command: "coffee"
    "Selection Based": (code) -> ['-e', code]
    "File Based": (filename) -> [filename]

  JavaScript:
    command: "node"
    "Selection Based": (code) -> ['-e', code]
    "File Based": (filename) -> [filename]

  Ruby:
    command: "ruby"
    "Selection Based": (code) -> ['-e', code]
    "File Based": (filename) -> [filename]

  Perl:
    command: "perl"
    "Selection Based": (code) -> ['-e', code]
    "File Based": (filename) -> [filename]

  PHP:
    command: "php"
    "Selection Based": (code) -> ['-r', code]
    "File Based": (filename) -> [filename]

  Python:
    command: "python"
    "Selection Based": (code) -> ['-c', code]
    "File Based": (filename) -> [filename]

  'Shell Script (Bash)':
    command: "bash"
    "Selection Based": (code) -> ['-c', code]
    "File Based": (filename) -> [filename]

  Go:
    command: "go"
    #"Selection Based": (code) -> []
    "File Based": (filename) -> ['run', filename]

  'F#':
    command: "fsharpi"
    "File Based": (filename) -> ['--exec', filename]
