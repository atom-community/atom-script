"use babel"

import GrammarUtils from "../grammar-utils"
const { command } = GrammarUtils

const FortranFixedForm = {
  "File Based": {
    command,
    args({ filepath }) {
      const cmd = `gfortran '${filepath}' -ffixed-form -o /tmp/f.out && /tmp/f.out`
      return GrammarUtils.formatArgs(cmd)
    },
  },
}
const FortranFreeForm = {
  "File Based": {
    command,
    args({ filepath }) {
      const cmd = `gfortran '${filepath}' -ffree-form -o /tmp/f90.out && /tmp/f90.out`
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
