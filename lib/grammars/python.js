"use babel"

import GrammarUtils from "../grammar-utils"

// https://github.com/atom-community/atom-script/issues/214#issuecomment-418766763
let encodingSet = false
function setEncoding() {
  if (!encodingSet) {
    process.env.PYTHONIOENCODING = "utf-8"
    encodingSet = true
  }
}

export const Python = {
  "Selection Based": {
    command: "python",
    args(context) {
      setEncoding()
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code)
      return ["-u", tmpFile]
    },
  },

  "File Based": {
    command: "python",
    args({ filepath }) {
      setEncoding()
      return ["-u", filepath]
    },
  },
}

export const MagicPython = Python

export const Sage = {
  "Selection Based": {
    command: "sage",
    args(context) {
      setEncoding()
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code)
      return [tmpFile]
    },
  },

  "File Based": {
    command: "sage",
    args({ filepath }) {
      setEncoding()
      return [filepath]
    },
  },
}
