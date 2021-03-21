"use babel"

import grammarMap from "./grammars/index"

import * as apple from "./grammars/apple"
import c from "./grammars/c"
import coffeescript from "./grammars/coffeescript"
import database from "./grammars/database"
import doc from "./grammars/doc"
import * as fortran from "./grammars/fortran"
import * as haskell from "./grammars/haskell"
import * as java from "./grammars/java"
import * as js from "./grammars/javascript"
import lisp from "./grammars/lisp"
import * as lua from "./grammars/lua"
import ml from "./grammars/ml"
import * as perl from "./grammars/perl"
import php from "./grammars/php"
import * as python from "./grammars/python"
import ruby from "./grammars/ruby"
import * as shell from "./grammars/shell"
import * as windows from "./grammars/windows"

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
