"use babel"

/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let GrammarUtils
import path from "path"
const { command } = (GrammarUtils = require("../grammar-utils"))

const windows = GrammarUtils.OperatingSystem.isWindows()

const args = function (filepath, jar) {
  jar = (jar != null ? jar : path.basename(filepath)).replace(/\.kt$/, ".jar")
  const cmd = `kotlinc '${filepath}' -include-runtime -d ${jar} && java -jar ${jar}`
  return GrammarUtils.formatArgs(cmd)
}

export const Java = {
  "File Based": {
    command,
    args(context) {
      const className = GrammarUtils.Java.getClassName(context)
      const classPackages = GrammarUtils.Java.getClassPackage(context)
      const sourcePath = GrammarUtils.Java.getProjectPath(context)
      if (windows) {
        return [`/c javac -Xlint ${context.filename} && java ${className}`]
      } else {
        return [
          "-c",
          `javac -J-Dfile.encoding=UTF-8 -sourcepath '${sourcePath}' -d /tmp '${context.filepath}' && java -Dfile.encoding=UTF-8 -cp /tmp:%CLASSPATH ${classPackages}${className}`,
        ]
      }
    },
  },
}

export const Kotlin = {
  "Selection Based": {
    command,
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code, ".kt")
      return args(tmpFile)
    },
  },
  "File Based": {
    command,
    args({ filepath, filename }) {
      return args(filepath, `/tmp/${filename}`)
    },
  },
}

export const Processing = {
  "File Based": {
    command: "processing-java",
    args({ filepath }) {
      return [`--sketch=${path.dirname(filepath)}`, "--run"]
    },
  },
}
