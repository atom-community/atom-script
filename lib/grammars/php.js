"use babel"

import GrammarUtils from "../grammar-utils"

const PerlGrammars = {
  "Behat Feature": {
    "File Based": {
      command: "behat",
      args({ filepath }) {
        return [filepath]
      },
    },

    "Line Number Based": {
      command: "behat",
      args(context) {
        return [context.fileColonLine()]
      },
    },
  },

  PHP: {
    "Selection Based": {
      command: "php",
      args(context) {
        const code = context.getCode()
        const tmpFile = GrammarUtils.PHP.createTempFileWithCode(code)
        return [tmpFile]
      },
    },

    "File Based": {
      command: "php",
      args({ filepath }) {
        return [filepath]
      },
    },
  },
}
export default PerlGrammars
