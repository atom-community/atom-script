"use babel"

const message =
  "SQL requires setting 'Script: Run Options' directly. See https://github.com/atom-ide-community/atom-script/tree/master/examples/hello.sql for further information."

const DataBaseGrammars = {
  "mongoDB (JavaScript)": {
    "Selection Based": {
      command: "mongo",
      args(context) {
        return ["--eval", context.getCode()]
      },
    },

    "File Based": {
      command: "mongo",
      args({ filepath }) {
        return [filepath]
      },
    },
  },

  SQL: {
    "Selection Based": {
      command: "echo",
      args() {
        return [message]
      },
    },

    "File Based": {
      command: "echo",
      args() {
        return [message]
      },
    },
  },

  "SQL (PostgreSQL)": {
    "Selection Based": {
      command: "psql",
      args(context) {
        return ["-c", context.getCode()]
      },
    },

    "File Based": {
      command: "psql",
      args({ filepath }) {
        return ["-f", filepath]
      },
    },
  },
}
export default DataBaseGrammars
