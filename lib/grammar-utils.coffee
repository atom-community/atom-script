# Require some libs used for creating temporary files
os = require 'os'
fs = require 'fs'
path = require 'path'
uuid = require 'node-uuid'

# Public: GrammarUtils - utilities for determining how to run code
module.exports =
  tempFilesDir: path.join(os.tmpdir(), 'atom_script_tempfiles')

  # Public: Create a temporary file with the provided code
  #
  # * `code`    A {String} containing some code
  #
  # Returns the {String} filepath of the new file
  createTempFileWithCode: (code) ->
    if (!fs.existsSync(@tempFilesDir))
      fs.mkdirSync(@tempFilesDir)
    if (!fs.existsSync(@tempFilesDir))
      throw "Unable to create directory for temporary files " + @tempFilesDir

    tempFilePath = @tempFilesDir + path.sep + uuid.v1()
    if (file = fs.openSync(tempFilePath, 'w'))
      fs.writeSync(file, code)
      fs.closeSync(file)
      return tempFilePath
    else
      throw "Unable to create temporary file " + tempFilePath

  # Public: Delete all temporary files created by {GrammarUtils::createTempFileWithCode}
  deleteTempFiles: ->
    if (fs.existsSync(@tempFilesDir))
      files = fs.readdirSync(@tempFilesDir);
      if (files.length > 0)
          files.forEach((file, index) -> fs.unlinkSync(module.exports.tempFilesDir + path.sep + file))
      fs.rmdirSync(@tempFilesDir)

  # Public: Get the Lisp helper object
  #
  # Returns an {Object} which assists in splitting Lisp statements.
  Lisp: require './grammar-utils/lisp'

  # Public: Get the OperatingSystem helper object
  #
  # Returns an {Object} which assists in writing OS dependent code.
  OperatingSystem: require './grammar-utils/operating-system'

  # Public: Get the PHP helper object
  #
  # Returns an {Object} which assists in creating temp files containing PHP code
  PHP: require './grammar-utils/php'
