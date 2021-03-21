"use babel"

// Public: GrammarUtils.Perl - a module which assist the creation of Perl temporary files
const GrammarUtilsPerl = {
  // Public: Create a temporary file with the provided Perl code
  //
  // * `code`    A {String} containing some Perl code
  //
  // Returns the {String} filepath of the new file
  createTempFileWithCode(code) {
    return module.parent.exports.createTempFileWithCode(code)
  },
}
export default GrammarUtilsPerl
