# Maps Atom Grammar names to the interpreter used by that language
# As well as any special setup for arguments.
module.exports =
  CoffeeScript:
    interpreter: "coffee"
    makeargs: (code) -> ['-e', code]
  JavaScript:
    interpreter: "node"
    makeargs: (code) -> ['-e', code]
  Ruby:
    interpreter: "ruby"
    makeargs: (code) -> ['-e', code]
  Perl:
    interpreter: "perl"
    makeargs: (code) -> ['-e', code]
  PHP:
    interpreter: "php"
    makeargs: (code) -> ['-r', code]
  Python:
    interpreter: "python"
    makeargs: (code) -> ['-c', code]
  'Shell Script (Bash)':
    interpreter: "bash"
    makeargs: (code) -> ['-c', code]
