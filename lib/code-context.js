module.exports =
class CodeContext
  filename: null
  filepath: null
  lineNumber: null
  shebang: null
  textSource: null

  # Public: Initializes a new {CodeContext} object for the given file/line
  #
  # @filename   - The {String} filename of the file to execute.
  # @filepath   - The {String} path of the file to execute.
  # @textSource - The {String} text to under "Selection Based". (default: null)
  #
  # Returns a newly created {CodeContext} object.
  constructor: (@filename, @filepath, @textSource = null) ->

  # Public: Creates a {String} representation of the file and line number
  #
  # fullPath - Whether to expand the file path. (default: true)
  #
  # Returns the "file colon line" {String}.
  fileColonLine: (fullPath = true) ->
    if fullPath
      fileColonLine = @filepath
    else
      fileColonLine = @filename

    return fileColonLine unless @lineNumber
    "#{fileColonLine}:#{@lineNumber}"

  # Public: Retrieves the text from whatever source was given on initialization
  #
  # prependNewlines - Whether to prepend @lineNumber newlines (default: true)
  #
  # Returns the code selection {String}
  getCode: (prependNewlines = true) ->
    code = @textSource?.getText()
    return code unless prependNewlines and @lineNumber

    newlineCount = Number(@lineNumber)
    newlines = Array(newlineCount).join("\n")
    "#{newlines}#{code}"

  # Public: Retrieves the command name from @shebang
  #
  # Returns the {String} name of the command or {undefined} if not applicable.
  shebangCommand: ->
    sections = @shebangSections()
    return unless sections

    sections[0]

  # Public: Retrieves the command arguments (such as flags or arguments to
  # /usr/bin/env) from @shebang
  #
  # Returns the {String} name of the command or {undefined} if not applicable.
  shebangCommandArgs: ->
    sections = @shebangSections()
    return [] unless sections

    sections[1..sections.length-1]

  # Public: Splits the shebang string by spaces to extra the command and
  # arguments
  #
  # Returns the {String} name of the command or {undefined} if not applicable.
  shebangSections: ->
    @shebang?.split(' ')
