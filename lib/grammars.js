'use babel';

import grammarMap from './grammars/index.coffee';

import apple from './grammars/apple.coffee';
import c from './grammars/c.coffee';
import coffeescript from './grammars/coffeescript.coffee';
import database from './grammars/database.coffee';
import doc from './grammars/doc.coffee';
import fortran from './grammars/fortran.coffee';
import haskell from './grammars/haskell.coffee';
import java from './grammars/java.coffee';
import js from './grammars/javascript';
import lisp from './grammars/lisp.coffee';
import lua from './grammars/lua.coffee';
import ml from './grammars/ml.coffee';
import perl from './grammars/perl.coffee';
import php from './grammars/php.coffee';
import python from './grammars/python.coffee';
import ruby from './grammars/ruby.coffee';
import shell from './grammars/shell.coffee';
import windows from './grammars/windows.coffee';

export default {
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
};
