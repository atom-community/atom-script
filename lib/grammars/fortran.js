"use babel"

import path from "path"
import GrammarUtils from "../grammar-utils"
const { command } = GrammarUtils

exports["Fortran - Fixed Form"] = {
  "File Based": {
    command,
    args({ filepath }) {
      const cmd = `gfortran '${filepath}' -ffixed-form -o /tmp/f.out && /tmp/f.out`
      return GrammarUtils.formatArgs(cmd)
    },
  },
}
exports["Fortran - Free Form"] = {
  "File Based": {
    command,
    args({ filepath }) {
      const cmd = `gfortran '${filepath}' -ffree-form -o /tmp/f90.out && /tmp/f90.out`
      return GrammarUtils.formatArgs(cmd)
    },
  },
}
exports["Fortran - Modern"] = exports["Fortran - Free Form"]
exports["Fortran - Punchcard"] = exports["Fortran - Fixed Form"]
