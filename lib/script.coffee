ScriptView = require './script-view'

module.exports =
  scriptView: null

  activate: (state) ->
    @scriptView = new ScriptView(state.scriptViewState)

  deactivate: ->
    @scriptView.destroy()

  serialize: ->
    scriptViewState: @scriptView.serialize()

  configDefaults:
    grammars:    
      'CoffeeScript':
        command: "coffee"
        "Selection Based": (code) -> ['-e', code]
        "File Based": (filename) -> [filename]
      'JavaScript':
        command: "node"
        "Selection Based": (code) -> ['-e', code]
        "File Based": (filename) -> [filename]
      'Ruby':
        command: "ruby"
        "Selection Based": (code) -> ['-e', code]
        "File Based": (filename) -> [filename]
      'Perl':
        command: "perl"
        "Selection Based": (code) -> ['-e', code]
        "File Based": (filename) -> [filename]
      'PHP':
        command: "php"
        "Selection Based": (code) -> ['-r', code]
        "File Based": (filename) -> [filename]
      'Python':
        command: "python"
        "Selection Based": (code) -> ['-c', code]
        "File Based": (filename) -> [filename]
      'Shell Script (Bash)':
        command: "bash"
        "Selection Based": (code) -> ['-c', code]
        "File Based": (filename) -> [filename]
      'Go':
        command: "go"
        "File Based": (filename) -> ['run', filename]
      'F#':
        command: "fsharpi"
        "File Based": (filename) -> ['--exec', filename]
      'newLISP':
        command: "newlisp"
        "Selection Based": (code) -> ['-e', code]
        "File Based": (filename) -> [filename]
