"use babel"

/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import GrammarUtils from "../grammar-utils"
const { command } = GrammarUtils

// const windows = GrammarUtils.OperatingSystem.isWindows()

const MLGrammars = {
  BuckleScript: {
    "Selection Based": {
      command: "bsc",
      args(context) {
        const code = context.getCode()
        const tmpFile = GrammarUtils.createTempFileWithCode(code)
        return ["-c", tmpFile]
      },
    },

    "File Based": {
      command: "bsc",
      args({ filepath }) {
        return ["-c", filepath]
      },
    },
  },

  OCaml: {
    "File Based": {
      command: "ocaml",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  Reason: {
    "File Based": {
      command,
      args({ filename }) {
        const file = filename.replace(/\.re$/, ".native")
        return GrammarUtils.formatArgs(`rebuild '${file}' && '${file}'`)
      },
    },
  },

  "Standard ML": {
    "File Based": {
      command: "sml",
      args({ filename }) {
        return [filename]
      },
    },

    "Selection Based": {
      command: "sml",
      args(context) {
        const code = context.getCode()
        const tmpFile = GrammarUtils.createTempFileWithCode(code, ".sml")
        return [tmpFile]
      },
    },
  },
}
export default MLGrammars
