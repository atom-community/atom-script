"use babel"

const Factor = {
  "File Based": {
    command: "factor",
    args({ filepath }) {
      return [filepath]
    },
  },
}

export default { Factor }
