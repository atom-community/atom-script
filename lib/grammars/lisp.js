"use babel"

import _ from "underscore"
import GrammarUtils from "../grammar-utils"

const LispGrammars = {
  "Common Lisp": {
    "File Based": {
      command: "clisp",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  Lisp: {
    "Selection Based": {
      command: "sbcl",
      args(context) {
        const statements = _.flatten(
          _.map(GrammarUtils.Lisp.splitStatements(context.getCode()), (statement) => ["--eval", statement])
        )
        return _.union(["--noinform", "--disable-debugger", "--non-interactive", "--quit"], statements)
      },
    },

    "File Based": {
      command: "sbcl",
      args({ filepath }) {
        return ["--noinform", "--script", filepath]
      },
    },
  },

  newLISP: {
    "Selection Based": {
      command: "newlisp",
      args(context) {
        return ["-e", context.getCode()]
      },
    },
    "File Based": {
      command: "newlisp",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  Scheme: {
    "Selection Based": {
      command: "guile",
      args(context) {
        return ["-c", context.getCode()]
      },
    },
    "File Based": {
      command: "guile",
      args({ filepath }) {
        return [filepath]
      },
    },
  },
}
export default LispGrammars
