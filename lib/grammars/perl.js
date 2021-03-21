"use babel"

import GrammarUtils from "../grammar-utils"

export const Perl = {
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

exports.Raku = {
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

exports["Perl 6"] = exports.Raku
