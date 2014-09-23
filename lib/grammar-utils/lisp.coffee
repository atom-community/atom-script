#Utilities for particular grammars
_ = require 'underscore'

module.exports =
  splitStatements: (code) ->
    reducer = (statements, char, i, code) ->
      if char == '('
        @parenDepth = (@parenDepth or 0) + 1
        @inStatement = true
      else if char == ')'
        @parenDepth = (@parenDepth or 0) - 1

      @statement = (@statement or '') + char

      if @parenDepth == 0 and @inStatement
        @inStatement = false
        statements.push @statement.trim()
        @statement = ''

      return statements

    statements = _.reduce code.trim(), reducer, [], {}

    return statements
