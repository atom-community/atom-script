"use babel"

import * as path from "path"
import GrammarUtils from "../grammar-utils"
const { command } = GrammarUtils

const bin = path.join(__dirname, "../..", "node_modules", ".bin")
const coffee = path.join(bin, "coffee")
const babel = path.join(
  __dirname,
  "../..",
  "node_modules",
  ".bin",
  GrammarUtils.OperatingSystem.isWindows() ? "babel-node.cmd" : "babel-node"
)
const babelConfig = path.join(__dirname, "babel.config.js")

const rimraf = path.join(
  __dirname,
  "../..",
  "node_modules",
  ".bin",
  GrammarUtils.OperatingSystem.isWindows() ? "rimraf.cmd" : "rimraf"
)

function coffeeArgs({ filepath }) {
  let filePathOutput = filepath
  const extension = filepath.substring(filepath.indexOf(".") + 1)
  filePathOutput = filePathOutput.replace(extension, "js")
  const cmd = `'${coffee}' --compile '${filepath}' && ${babel} ${filePathOutput} --config-file ${babelConfig}' && ${rimraf} ${filePathOutput}`
  return GrammarUtils.formatArgs(cmd)
}

const CoffeeScript = {
  "Selection Based": {
    command,
    args(context) {
      const editor = atom.workspace.getActiveTextEditor()
      const scopeName = editor ? editor.getGrammar().scopeName : null
      const isLiterate = scopeName !== null && scopeName.includes("lit")
      const lit = isLiterate ? "lit" : ""
      const code = context.getCode()
      const filepath = GrammarUtils.createTempFileWithCode(code, `.${lit}coffee`)
      return coffeeArgs({ filepath, isLiterate })
    },
  },
  "File Based": { command, args: coffeeArgs },
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
