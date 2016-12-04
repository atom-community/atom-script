CodeContext = require './code-context'
grammarMap = require './grammars'

{Emitter} = require 'atom'

module.exports =
class CodeContextBuilder
  constructor: (@emitter = new Emitter) ->

  destroy: ->
    @emitter.dispose()

  # Public: Builds code context for specified argType
  #
  # editor - Atom's {TextEditor} instance
  # argType - {String} with one of the following values:
  #
  # * "Selection Based" (default)
  # * "Line Number Based",
  # * "File Based"
  #
  # returns a {CodeContext} object
  buildCodeContext: (editor, argType='Selection Based') ->
    return unless editor?

    codeContext = @initCodeContext(editor)

    codeContext.argType = argType

    if argType == 'Line Number Based'
      editor.save()
    else if codeContext.selection.isEmpty() and codeContext.filepath?
      codeContext.argType = 'File Based'
      editor.save() if editor?.isModified()

    # Selection and Line Number Based runs both benefit from knowing the current line
    # number
    unless argType == 'File Based'
      cursor = editor.getLastCursor()
      codeContext.lineNumber = cursor.getScreenRow() + 1

    return codeContext

  initCodeContext: (editor) ->
    filename = editor.getTitle()
    filepath = editor.getPath()
    selection = editor.getLastSelection()
    ignoreSelection = atom.config.get 'script.ignoreSelection'

    # If the selection was empty or if ignore selection is on, then "select" ALL
    # of the text
    # This allows us to run on new files
    if selection.isEmpty() || ignoreSelection
      textSource = editor
    else
      textSource = selection

    codeContext = new CodeContext(filename, filepath, textSource)
    codeContext.selection = selection
    codeContext.shebang = @getShebang(editor)

    lang = @getLang(editor)

    if @validateLang lang
      codeContext.lang = lang

    return codeContext

  getShebang: (editor) ->
    return unless process.platform isnt 'win32'
    text = editor.getText()
    lines = text.split("\n")
    firstLine = lines[0]
    return unless firstLine.match(/^#!/)

    firstLine.replace(/^#!\s*/, '')

  getLang: (editor) ->
    editor.getGrammar().name

  validateLang: (lang) ->
    valid = true

    # Determine if no language is selected.
    if lang is 'Null Grammar' or lang is 'Plain Text'
      @emitter.emit 'did-not-specify-language'
      valid = false

    # Provide them a dialog to submit an issue on GH, prepopulated with their
    # language of choice.
    else if not (lang of grammarMap)
      @emitter.emit 'did-not-support-language', { lang: lang }
      valid = false

    return valid

  onDidNotSpecifyLanguage: (callback) ->
    @emitter.on 'did-not-specify-language', callback

  onDidNotSupportLanguage: (callback) ->
    @emitter.on 'did-not-support-language', callback
