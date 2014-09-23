_ = require 'underscore'

module.exports =
  splitStatements: (code) ->
    iterator = (statements, currentCharacter, _memo, _context) ->
      @parenDepth ?= 0
      if currentCharacter is '('
        @parenDepth += 1
        @inStatement = true
      else if currentCharacter is ')'
        @parenDepth -= 1

      @statement ?= ''
      @statement += currentCharacter

      if @parenDepth is 0 and @inStatement
        @inStatement = false
        statements.push @statement.trim()
        @statement = ''

      return statements

    statements = _.reduce code.trim(), iterator, [], {}

    return statements
