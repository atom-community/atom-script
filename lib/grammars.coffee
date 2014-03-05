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
    bySelectionArgs: (code) -> ['-e', code]
    byFileArgs: defaultFileArgs
  Ruby:
    command: "ruby"
    bySelectionArgs: (code) -> ['-e', code]
    byFileArgs: defaultFileArgs
  Perl:
    command: "perl"
    bySelectionArgs: (code) -> ['-e', code]
    byFileArgs: defaultFileArgs
  PHP:
    command: "php"
    bySelectionArgs: (code) -> ['-r', code]
    byFileArgs: defaultFileArgs
  Python:
    command: "python"
    bySelectionArgs: (code) -> ['-c', code]
    byFileArgs: defaultFileArgs
  'Shell Script (Bash)':
    command: "bash"
    bySelectionArgs: (code) -> ['-c', code]
    byFileArgs: defaultFileArgs
  Go:
    command: "go"
    byFileArgs: (filename) -> ['run', filename]
