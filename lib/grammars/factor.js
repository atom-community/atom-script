"use babel"

const Factor = {
  "Selection Based": {
    command: "factor",
    args({ selection }) {
      return ["-e=<< USE: parser auto-use >> " + selection.getText()]
    },
  },

  "File Based": {
    command: "factor",
    args({ filepath }) {
      return [filepath]
    },
  },
}

export default { Factor }
