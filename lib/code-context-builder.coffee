CodeContext = require './code-context'
grammarMap = require './grammars'

module.exports =
class CodeContextBuilder
  constructor: (@view, @editor) ->

  initCodeContext: ->
    filename = @editor.getTitle()
    filepath = @editor.getPath()
    selection = @editor.getLastSelection()

    # If the selection was empty "select" ALL the text
    # This allows us to run on new files
    if selection.isEmpty()
      textSource = @editor
    else
      textSource = selection

    codeContext = new CodeContext(filename, filepath, textSource)
    codeContext.selection = selection
    codeContext.shebang = @getShebang(@editor)

    # Get language
    lang = @getLang @editor

    if @validateLang lang
      codeContext.lang = lang

    return codeContext

  getShebang: ->
    text = @editor.getText()
    lines = text.split("\n")
    firstLine = lines[0]
    return unless firstLine.match(/^#!/)

    firstLine.replace(/^#!\s*/, '')

  getLang: -> @editor.getGrammar().name

  validateLang: (lang) ->
    valid = true
    # Determine if no language is selected.
    if lang is 'Null Grammar' or lang is 'Plain Text'
      @view.showNoLanguageSpecified()
      valid = false

    # Provide them a dialog to submit an issue on GH, prepopulated with their
    # language of choice.
    else if not (lang of grammarMap)
      @view.showLanguageNotSupported(lang)
      valid = false

    return valid
