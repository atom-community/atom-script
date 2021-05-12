"use babel"

/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import path from "path"
import GrammarUtils from "../grammar-utils"
const { command } = GrammarUtils

const windows = GrammarUtils.OperatingSystem.isWindows()

export const Java = {
  "File Based": {
    command,
    args(context) {
      const className = GrammarUtils.Java.getClassName(context)
      const classPackages = GrammarUtils.Java.getClassPackage(context)
      const sourcePath = GrammarUtils.Java.getProjectPath(context)
      const tempFolder = GrammarUtils.createTempFolder("jar-")
      const cmd = `javac -encoding UTF-8 -sourcepath '${sourcePath}' -d '${tempFolder}' '${context.filepath}' && java -D'file.encoding'='UTF-8' -cp '${tempFolder}' ${classPackages}${className}`
      return GrammarUtils.formatArgs(cmd)
    },
  },
}

function KotlinArgs(filepath, jar) {
  const jarNew = (jar !== null ? jar : path.basename(filepath)).replace(/\.kt$/, ".jar")
  const cmd = `kotlinc '${filepath}' -include-runtime -o ${jarNew} && java -jar ${jarNew}`
  return GrammarUtils.formatArgs(cmd)
}

export const Kotlin = {
  "Selection Based": {
    command,
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code, ".kt")
      return KotlinArgs(tmpFile, null)
    },
  },
  "File Based": {
    command,
    args({ filepath, filename }) {
      return KotlinArgs(filepath, path.join(GrammarUtils.createTempFolder("kt-"), filename))
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
