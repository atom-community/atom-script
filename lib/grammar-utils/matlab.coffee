# Require some libs used for creating temporary files
os = require 'os'
fs = require 'fs'
path = require 'path'
uuid = require 'node-uuid'

# Public: GrammarUtils.MATLAB - a module which assist the creation of MATLAB temporary files
module.exports =
  tempFilesDir: path.join(os.tmpdir(), 'atom_script_tempfiles')

  # Public: Create a temporary file with the provided MATLAB code
  #
  # * `code`    A {String} containing some MATLAB code
  #
  # Returns the {String} filepath of the new file
  createTempFileWithCode: (code) ->
    try
      fs.mkdirSync(@tempFilesDir) unless fs.existsSync(@tempFilesDir)

      tempFilePath = @tempFilesDir + path.sep + 'm' + uuid.v1().split('-').join('_')  + '.m'

      file = fs.openSync(tempFilePath, 'w')
      fs.writeSync(file, code)
      fs.closeSync(file)

      tempFilePath
    catch error
      throw ("Error while creating temporary file (#{error})")
