_ = require 'underscore'

# Public: GrammarUtils.Lisp - a module which exposes the ability to evaluate
# code
module.exports =
  # Public: Split a string of code into an array of executable statements
  #
  # Returns an {Array} of executable statements.
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
