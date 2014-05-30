{WorkspaceView} = require 'atom'
CodeContext = require '../lib/code-context'

describe 'CodeContext', ->
  beforeEach ->
    atom.workspaceView = new WorkspaceView
    textSource = atom.workspace.getActiveEditor()
    @codeContext = new CodeContext('test.txt', '/tmp/test.txt', null)

  describe 'fileColonLine', ->
    it 'returns the full filepath and line number when fullPath is truthy', ->
      expect(@codeContext.fileColonLine()).toMatch(/^test\.txt$/);
      expect(@codeContext.fileColonLine(true)).toMatch(/^test\.txt$/);

    it 'returns only the filename and line number when fullPath is falsy', ->
      expect(@codeContext.fileColonLine(false)).toMatch(/^\/tmp\/test\.txt$/);

  describe 'getCode', ->
    it 'returns undefined if no textSource is available', ->
      expect(@codeContext.getCode()).toBe(undefined)
