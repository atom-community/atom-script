'use babel';

// Public: GrammarUtils.PHP - a module which assist the creation of PHP temporary files
export default {
  // Public: Create a temporary file with the provided PHP code
  //
  // * `code`    A {String} containing some PHP code without <?php header
  //
  // Returns the {String} filepath of the new file
  createTempFileWithCode(code) {
    if (!/^[\s]*<\?php/.test(code)) { code = `<?php ${code}`; }
    return module.parent.exports.createTempFileWithCode(code);
  },
};
