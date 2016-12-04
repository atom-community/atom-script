# Require some libs used for creating temporary files
os = require 'os'
fs = require 'fs'
path = require 'path'
uuid = require 'node-uuid'

# Public: GrammarUtils.D - a module which assist the creation of D temporary files
module.exports =
  tempFilesDir: path.join(os.tmpdir(), 'atom_script_tempfiles')

  # Public: Create a temporary file with the provided D code
  #
  # * `code`    A {String} containing some D code
  #
  # Returns the {String} filepath of the new file
  createTempFileWithCode: (code) ->
    try
      fs.mkdirSync(@tempFilesDir) unless fs.existsSync(@tempFilesDir)

      tempFilePath = @tempFilesDir + path.sep + 'm' + uuid.v1().split('-').join('_')  + '.d'

      file = fs.openSync(tempFilePath, 'w')
      fs.writeSync(file, code)
      fs.closeSync(file)

      tempFilePath
    catch error
      throw ("Error while creating temporary file (#{error})")
