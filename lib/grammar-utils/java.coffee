# Java script preparation functions
os = require 'os'
path = require 'path'

module.exports =
  # Public: Get atom temp file directory
  #
  # Returns {String} containing atom temp file directory
  tempFilesDir: path.join(os.tmpdir())

  # Public: Get class name of file in context
  #
  # * `filePath`  {String} containing file path
  #
  # Returns {String} containing class name of file
  getClassName: (context) ->
    context.filename.replace /\.java$/, ""

  # Public: Get project path of context
  #
  # * `context`  {Object} containing current context
  #
  # Returns {String} containing the matching project path
  getProjectPath: (context) ->
    projectPaths = atom.project.getPaths()
    for projectPath in projectPaths
      if context.filepath.includes(projectPath)
        projectPath

  # Public: Get package of file in context
  #
  # * `context`  {Object} containing current context
  #
  # Returns {String} containing class of contextual file
  getClassPackage: (context) ->
    projectPath = module.exports.getProjectPath context
    projectRemoved = (context.filepath.replace projectPath + "/", "")
    projectRemoved.replace "/" + context.filename, ""
