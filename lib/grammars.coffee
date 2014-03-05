# Maps Atom Grammar names to the command used by that language
# As well as any special setup for arguments.

defaultFileArgs = (filename) -> [filename]

module.exports =
  CoffeeScript:
    command: "coffee"
    bySelectionArgs: (code) -> ['-e', code]
    byFileArgs: defaultFileArgs
  JavaScript:
    command: "node"
    selectionArgs: (code) -> ['-e', code]
    byFileArgs: defaultFileArgs
  Ruby:
    command: "ruby"
    selectionArgs: (code) -> ['-e', code]
    byFileArgs: defaultFileArgs
  Perl:
    command: "perl"
    selectionArgs: (code) -> ['-e', code]
    byFileArgs: defaultFileArgs
  PHP:
    command: "php"
    selectionArgs: (code) -> ['-r', code]
    byFileArgs: defaultFileArgs
  Python:
    command: "python"
    selectionArgs: (code) -> ['-c', code]
    byFileArgs: defaultFileArgs
  'Shell Script (Bash)':
    command: "bash"
    selectionArgs: (code) -> ['-c', code]
    byFileArgs: defaultFileArgs
