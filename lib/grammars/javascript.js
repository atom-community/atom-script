"use babel"

import path from "path"
import GrammarUtils from "../grammar-utils"

const babel = path.join(
  __dirname,
  "../..",
  "node_modules",
  ".bin",
  GrammarUtils.OperatingSystem.isWindows() ? "babel-node.cmd" : "babel-node"
)
const babelConfig = path.join(__dirname, "babel.config.js")

const JavaScript = {
  "Selection Based": {
    command: babel,
    args: (context) => {
      const code = context.getCode()
      const filepath = GrammarUtils.createTempFileWithCode(code, ".js")
      return [filepath, "--config-file", babelConfig]
    },
  },
  "File Based": {
    command: babel,
    args: ({ filepath }) => [filepath, "--config-file", babelConfig],
  },
}
const Babel = JavaScript
const JSX = JavaScript

const TypeScript = {
  "Selection Based": {
    command: "ts-node",
    args: (context) => ["-e", context.getCode()],
  },
  "File Based": {
    command: "ts-node",
    args: ({ filepath }) => [filepath],
  },
}

const Dart = {
  "Selection Based": {
    command: "dart",
    args: (context) => {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code, ".dart")
      return [tmpFile]
    },
  },
  "File Based": {
    command: "dart",
    args: ({ filepath }) => [filepath],
  },
}

const JXA = {
  "Selection Based": {
    command: "osascript",
    args: (context) => ["-l", "JavaScript", "-e", context.getCode()],
  },
  "File Based": {
    command: "osascript",
    args: ({ filepath }) => ["-l", "JavaScript", filepath],
  },
}

const JavaScriptGrammars = {
  JavaScript,
  "Babel ES6 JavaScript": Babel,
  "JavaScript with JSX": JSX,
  Dart,
  "JavaScript for Automation (JXA)": JXA,
  TypeScript,
}
export default JavaScriptGrammars
