'use babel';

// Public: GrammarUtils.R - a module which assist the creation of R temporary files
export default {
  // Public: Create a temporary file with the provided R code
  //
  // * `code`    A {String} containing some R code
  //
  // Returns the {String} filepath of the new file
  createTempFileWithCode(code) {
    return module.parent.exports.createTempFileWithCode(code);
  },
};
