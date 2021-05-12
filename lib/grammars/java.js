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
      if (windows) {
        return [`/c javac ーJ-Dfile.encoding=UTF-8 -Xlint ${context.filename} && java -Dfile.encoding=UTF-8 ${className}`]
      } else {
        return [
          "-c",
          `javac -J-Dfile.encoding=UTF-8 -sourcepath '${sourcePath}' -d /tmp '${context.filepath}' && java -Dfile.encoding=UTF-8 -cp /tmp:%CLASSPATH ${classPackages}${className}`,
        ]
      }
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
