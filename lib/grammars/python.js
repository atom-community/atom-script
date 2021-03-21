"use babel"

import GrammarUtils from "../grammar-utils"

export const Python = {
  "Selection Based": {
    command: "python",
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code)
      return ["-u", tmpFile]
    },
  },

  "File Based": {
    command: "python",
    args({ filepath }) {
      return ["-u", filepath]
    },
  },
}

export const MagicPython = Python

export const Sage = {
  "Selection Based": {
    command: "sage",
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code)
      return [tmpFile]
    },
  },

  "File Based": {
    command: "sage",
    args({ filepath }) {
      return [filepath]
    },
  },
}
