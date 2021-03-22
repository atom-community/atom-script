"use babel"

import GrammarUtils from "../grammar-utils"
const { command } = GrammarUtils

const FortranFixedForm = {
  "File Based": {
    command,
    args({ filepath }) {
      const tempOutFile = GrammarUtils.createTempPath("f-", ".out")
      const cmd = `gfortran '${filepath}' -ffixed-form -o ${tempOutFile} && ${tempOutFile}`
      return GrammarUtils.formatArgs(cmd)
    },
  },
}
const FortranFreeForm = {
  "File Based": {
    command,
    args({ filepath }) {
      const tempOutFile = GrammarUtils.createTempPath("f90-", ".out")
      const cmd = `gfortran '${filepath}' -ffree-form -o ${tempOutFile} && ${tempOutFile}`
      return GrammarUtils.formatArgs(cmd)
    },
  },
}
const FortranModern = FortranFreeForm
const FortranPunchcard = FortranFixedForm

const Fortran = {
  Fortran: FortranModern,
  "Fortran - Fixed Form": FortranFixedForm,
  "Fortran - Free Form": FortranFreeForm,
  "Fortran - Modern": FortranModern,
  "Fortran - Punchcard": FortranPunchcard,
}
export default Fortran
