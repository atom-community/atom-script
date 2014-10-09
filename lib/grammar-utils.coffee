# Public: GrammarUtils - utilities for determining how to run code
module.exports =
  # Public: Get the Lisp helper object
  #
  # Returns an {Object} which assists in splitting Lisp statements.
  Lisp: require './grammar-utils/lisp'

  # Public: Get the OperatingSystem helper object
  #
  # Returns an {Object} which assists in writing OS dependent code.
  OperatingSystem: require './grammar-utils/operating-system'
