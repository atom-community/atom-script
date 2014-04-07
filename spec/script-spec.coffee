script = require '../lib/script'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe 'script', ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('script')

  describe 'when the script:toggle event is triggered', ->
    it 'attaches and then detaches the view', ->
      expect(atom.workspaceView.find('.script')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'script:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.script')).toExist()
        atom.workspaceView.trigger 'script:toggle'
        expect(atom.workspaceView.find('.script')).not.toExist()
