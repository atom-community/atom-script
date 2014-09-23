#Utilities for particular grammars
_ = require 'underscore'

module.exports =
  splitStatements: (code) ->
    reducer = (statements, char, i, code) ->
      if char == '('
        this.parenDepth = (this.parenDepth or 0) + 1
        this.inStatement = true
      else if char == ')'
        this.parenDepth = (this.parenDepth or 0) - 1

      this.statement = (this.statement or '') + char

      if this.parenDepth == 0 and this.inStatement
        this.inStatement = false
        statements.push this.statement.trim()
        this.statement = ''

      return statements

    statements = _.reduce code.trim(), reducer, [], {}

    return statements
