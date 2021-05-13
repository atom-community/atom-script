"use babel"
import path from "path"
import GrammarUtils from "../grammar-utils"
const { command } = GrammarUtils

function JavaArgs(filepath, context) {
  const sourcePath = GrammarUtils.Java.getProjectPath(context)
  const className = GrammarUtils.Java.getClassName(context)
  const classPackages = GrammarUtils.Java.getClassPackage(context)
  const tempFolder = GrammarUtils.createTempFolder("jar-")
  const cmd = `javac -encoding UTF-8 -J-Dfile.encoding=UTF-8 -Xlint -sourcepath '${sourcePath}' -d '${tempFolder}' '${filepath}' && java -Dfile.encoding=UTF-8 -cp '${tempFolder}' ${classPackages}${className}`
  return GrammarUtils.formatArgs(cmd)
}

export const Java = {
  "Selection Based": {
    command,
    args(context) {
      const code = context.getCode()
      const tmpFile = GrammarUtils.createTempFileWithCode(code, ".java")
      return JavaArgs(tmpFile, context)
    },
  },
  "File Based": {
    command,
    args(context) {
      return JavaArgs(context.filepath, context)
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
