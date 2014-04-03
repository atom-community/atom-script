ScriptView = require './script-view'

module.exports =
  scriptView: null

  activate: (state) ->
    @scriptView = new ScriptView(state.scriptViewState)

  deactivate: ->
    @scriptView.close()

  serialize: ->
    scriptViewState: @scriptView.serialize()

  configDefaults:
    grammars:
      'CoffeeScript':
        command: "coffee"
        "Selection Run Flags": ['-e']
        "Run Flags": []
      'JavaScript':
        command: "node"
        "Selection Run Flags": ['-e']
        "Run Flags": []
      'Ruby':
        command: "ruby"
        "Selection Run Flags": ['-e']
        "Run Flags": []
      'Perl':
        command: "perl"
        "Selection Run Flags": ['-e']
        "Run Flags": []
      'PHP':
        command: "php"
        "Selection Run Flags": ['-r']
        "Run Flags": []
      'Python':
        command: "python"
        "Selection Run Flags": ['-c']
        "Run Flags": []
      'Shell Script (Bash)':
        command: "bash"
        "Selection Run Flags": ['-c']
        "Run Flags": []
      'Go':
        command: "go"
        "Run Flags": ['run']
      'F#':
        command: "fsharpi"
        "Run Flags": ['--exec']
      'newLISP':
        command: "newlisp"
        "Selection Run Flags": ['-e']
        "Run Flags": []
