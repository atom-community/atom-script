# Maps Atom Grammar names to the command used by that language
# As well as any special setup for arguments.

module.exports =
  CoffeeScript:
    command: "coffee"
    bySelectionArgs: (code) -> ['-e', code]
    byFileArgs: (filename) -> [filename]

  JavaScript:
    command: "node"
    bySelectionArgs: (code) -> ['-e', code]
    byFileArgs: (filename) -> [filename]

  Ruby:
    command: "ruby"
    bySelectionArgs: (code) -> ['-e', code]
    byFileArgs: (filename) -> [filename]

  Perl:
    command: "perl"
    bySelectionArgs: (code) -> ['-e', code]
    byFileArgs: (filename) -> [filename]

  PHP:
    command: "php"
    bySelectionArgs: (code) -> ['-r', code]
    byFileArgs: (filename) -> [filename]

  Python:
    command: "python"
    bySelectionArgs: (code) -> ['-c', code]
    byFileArgs: (filename) -> [filename]
  'Shell Script (Bash)':
    command: "bash"
    bySelectionArgs: (code) -> ['-c', code]
    byFileArgs: (filename) -> [filename]
    
  Go:
    command: "go"
    byFileArgs: (filename) -> ['run', filename]
