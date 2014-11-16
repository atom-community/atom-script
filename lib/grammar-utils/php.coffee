
# Public: GrammarUtils.PHP - a module which assist the creation of PHP temporary files
module.exports =
  # Public: Create a temporary file with the provided PHP code
  #
  # * `code`    A {String} containing some PHP code without <?php header
  #
  # Returns the {String} filepath of the new file
  createTempFileWithCode: (code) ->
    return module.parent.exports.createTempFileWithCode("<?php #{code}")
