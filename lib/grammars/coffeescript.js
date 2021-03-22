"use babel"

import path from "path"
import GrammarUtils from "../grammar-utils"
const { command } = GrammarUtils

const bin = path.join(__dirname, "../..", "node_modules", ".bin")
const coffee = path.join(bin, "coffee")
const babel = path.join(bin, "babel")
const babelConfig = path.join(__dirname, "babel.config.js")

const args = function ({ filepath }) {
  const cmd = `'${coffee}' -p '${filepath}'|'${babel}' --filename '${filepath} --config-file ${babelConfig}'| node`
  return GrammarUtils.formatArgs(cmd)
}

const CoffeeScript = {
  "Selection Based": {
    command,
    args(context) {
      const editor = atom.workspace.getActiveTextEditor()
      const scopeName = editor ? editor.getGrammar().scopeName : null
      const lit = scopeName !== null && scopeName.includes("lit") ? "lit" : ""
      const code = context.getCode()
      const filepath = GrammarUtils.createTempFileWithCode(code, `.${lit}coffee`)
      return args({ filepath })
    },
  },
  "File Based": { command, args },
}

const CoffeeScriptLiterate = CoffeeScript

const IcedCoffeeScript = {
  "Selection Based": {
    command: "iced",
    args(context) {
      return ["-e", context.getCode()]
    },
  },

  "File Based": {
    command: "iced",
    args({ filepath }) {
      return [filepath]
    },
  },
}

const CoffeeScriptGrammars = {
  CoffeeScript,
  "CoffeeScript (Literate)": CoffeeScriptLiterate,
  IcedCoffeeScript,
  "Iced CoffeeScript": IcedCoffeeScript,
}
export default CoffeeScriptGrammars
