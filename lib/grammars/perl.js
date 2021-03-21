"use babel"

import GrammarUtils from "../grammar-utils"

const Perl = {
  "Selection Based": {
    command: "perl",
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code)
      return [tmpFile]
    },
  },

  "File Based": {
    command: "perl",
    args({ filepath }) {
      return [filepath]
    },
  },
}

const Raku = {
  "Selection Based": {
    command: "raku",
    args(context) {
      return ["-e", context.getCode()]
    },
  },

  "File Based": {
    command: "raku",
    args({ filepath }) {
      return [filepath]
    },
  },
}

const Perl6 = Raku

const PerlGrammars = {
  Perl,
  Raku,
  "Perl 6": Perl6,
}
export default PerlGrammars
