"use babel"

import grammarMap from "./grammars/index"

import * as apple from "./grammars/apple"
import c from "./grammars/c"
import coffeescript from "./grammars/coffeescript"
import database from "./grammars/database"
import doc from "./grammars/doc"
import fortran from "./grammars/fortran"
import haskell from "./grammars/haskell"
import * as java from "./grammars/java"
import js from "./grammars/javascript"
import lisp from "./grammars/lisp"
import lua from "./grammars/lua"
import ml from "./grammars/ml"
import perl from "./grammars/perl"
import php from "./grammars/php"
import * as python from "./grammars/python"
import ruby from "./grammars/ruby"
import shell from "./grammars/shell"
import windows from "./grammars/windows"

const Grammars = {
  ...grammarMap,

  ...apple,
  ...c,
  ...coffeescript,
  ...database,
  ...doc,
  ...fortran,
  ...haskell,
  ...java,
  ...js,
  ...lisp,
  ...lua,
  ...ml,
  ...perl,
  ...php,
  ...python,
  ...ruby,
  ...shell,
  ...windows,
}
export default Grammars
