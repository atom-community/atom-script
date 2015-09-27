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
  createTempFileWithCode: (code, extension = "") ->
    try
      fs.mkdirSync(@tempFilesDir) unless fs.existsSync(@tempFilesDir)

      tempFilePath = @tempFilesDir + path.sep + uuid.v1() + extension

      file = fs.openSync(tempFilePath, 'w')
      fs.writeSync(file, code)
      fs.closeSync(file)

      tempFilePath
    catch error
      throw "Error while creating temporary file (#{error})"

  # Public: Delete all temporary files and the directory created by {GrammarUtils::createTempFileWithCode}
  deleteTempFiles: ->
    try
      if (fs.existsSync(@tempFilesDir))
        files = fs.readdirSync(@tempFilesDir);
        if (files.length)
          files.forEach((file, index) => fs.unlinkSync(@tempFilesDir + path.sep + file))
        fs.rmdirSync(@tempFilesDir)
    catch error
      throw "Error while deleting temporary files (#{error})"

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

  # Public: Get the Nim helper object
  #
  # Returns an {Object} which assists in selecting the right project file for Nim code
  Nim: require './grammar-utils/nim'
