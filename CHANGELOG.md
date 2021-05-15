## [3.32.2](https://github.com/atom-ide-community/atom-script/compare/v3.32.1...v3.32.2) (2021-05-15)


### Bug Fixes

* export gnuplot ([51132f0](https://github.com/atom-ide-community/atom-script/commit/51132f06e2f4811e1a4aba226f0b400780043042))
* fix gnuplot command was not exported ([#2474](https://github.com/atom-ide-community/atom-script/issues/2474)) ([3f3cc10](https://github.com/atom-ide-community/atom-script/commit/3f3cc1036a18e729593b5b39b27feabed54db90f))

## [3.32.1](https://github.com/atom-ide-community/atom-script/compare/v3.32.0...v3.32.1) (2021-05-13)


### Bug Fixes

* add xlint and file.encoding to Java ([#2471](https://github.com/atom-ide-community/atom-script/issues/2471)) ([e730f08](https://github.com/atom-ide-community/atom-script/commit/e730f08d2cc8954a6562fef4e905776585074b63)), closes [#1166](https://github.com/atom-ide-community/atom-script/issues/1166)

# [3.32.0](https://github.com/atom-ide-community/atom-script/compare/v3.31.3...v3.32.0) (2021-05-12)


### Bug Fixes

* fix execution of Java files + support UTF-8 encoding ([d73f270](https://github.com/atom-ide-community/atom-script/commit/d73f270b098d0c22144ec9b59c983bf62428f995))


### Features

* add selection based Java support ([8515200](https://github.com/atom-ide-community/atom-script/commit/85152009948648b8cc702f6d0fd0369f6851b8b4))

## [3.31.3](https://github.com/atom-ide-community/atom-script/compare/v3.31.2...v3.31.3) (2021-05-11)


### Bug Fixes

* set utf-8 encoding for Python ([eb4700d](https://github.com/atom-ide-community/atom-script/commit/eb4700d08d085dec678e94ae9add0afe738f17b4))

## [3.31.2](https://github.com/atom-ide-community/atom-script/compare/v3.31.1...v3.31.2) (2021-05-11)


### Bug Fixes

* fix kotlin for newer Kotlin versions ([#2468](https://github.com/atom-ide-community/atom-script/issues/2468)) ([75bd9f5](https://github.com/atom-ide-community/atom-script/commit/75bd9f5b0d978aadf10c55c9c0a7759d970bd96d))
* update dependencies ([16a07fd](https://github.com/atom-ide-community/atom-script/commit/16a07fdd44f1ad5499092ac444fef01c88d184ee))

## [3.31.1](https://github.com/atom-ide-community/atom-script/compare/v3.31.0...v3.31.1) (2021-03-23)


### Bug Fixes

* createTempFolder ([b96d7f5](https://github.com/atom-ide-community/atom-script/commit/b96d7f5632c2c17579428811309b078072dfad20))
* detect literate coffee ([b298ac0](https://github.com/atom-ide-community/atom-script/commit/b298ac0cd69f7338cea7c988889a3535448f20b1))
* fix eslint errors in KotlinArgs ([34b592a](https://github.com/atom-ide-community/atom-script/commit/34b592a4d2ce41b9c69a9f3aa1a7841b28457848))
* make sure temp directory exists ([256b8bb](https://github.com/atom-ide-community/atom-script/commit/256b8bb2501366a6fab34e7ba630854af9098df2))
* simplify workingDirectory ([f35783c](https://github.com/atom-ide-community/atom-script/commit/f35783cb3f4f04aafd33178148fca1690387c718))
* use babel-node for CoffeeScript ([3466e03](https://github.com/atom-ide-community/atom-script/commit/3466e03248643e3bbb4c57dc80e9e9d9dab34e51))
* use babel-node for JavaScript ([8581f8e](https://github.com/atom-ide-community/atom-script/commit/8581f8ef63cf385bbccde3b25fff6a5a031e8999))
* use createTempFolder in Kotlin ([5516681](https://github.com/atom-ide-community/atom-script/commit/5516681d8470f1bffa161ac9c47e3dce9bf029a5))
* use createTempPath for Asm ([82f708a](https://github.com/atom-ide-community/atom-script/commit/82f708a632022071e0a9ea4426a9365a3b881b4a))
* use createTempPath for Rust ([bb74d13](https://github.com/atom-ide-community/atom-script/commit/bb74d13010f260509ca6a5ef345b9bcd12ade23c))
* use createTempPath in C grammar ([49d62d3](https://github.com/atom-ide-community/atom-script/commit/49d62d36c5a68260715b4aa08d1b5a45293c12ab))
* use createTempPath in Cpp grammar ([6db2dfa](https://github.com/atom-ide-community/atom-script/commit/6db2dfa5089d02ec62f1dd18a434598776536bbf))
* use createTempPath in fortran grammar ([5b10e3b](https://github.com/atom-ide-community/atom-script/commit/5b10e3b6c12b56abe6c86b194c6710d8463daef3))
* use createTempPath in Obj-c and Obj-cpp grammar ([c61bb75](https://github.com/atom-ide-community/atom-script/commit/c61bb75220110925aeaea5d2c34d44901952a09a))
* use rimraf for deleting the temp folder ([00cd789](https://github.com/atom-ide-community/atom-script/commit/00cd789e629ae0556f8912750bec04c6baeb6f38))
* use temp in grammar-utils ([ccea0bf](https://github.com/atom-ide-community/atom-script/commit/ccea0bf375a4861d0fa90b669414d1177d0146ce))

# [3.31.0](https://github.com/atom-ide-community/atom-script/compare/v3.30.0...v3.31.0) (2021-03-22)


### Bug Fixes

* add use-babel ([cfe2bb2](https://github.com/atom-ide-community/atom-script/commit/cfe2bb21edc8a598c60c492e285ea647404410f0))
* fix coffeescript ([18724f5](https://github.com/atom-ide-community/atom-script/commit/18724f542e549c084de645bcecd8434ef895b20b))
* fix the C exports names ([2912212](https://github.com/atom-ide-community/atom-script/commit/29122127eed4c88ca2963597be0d07be8a874a7d))
* fix the CoffeeScript exports ([da8cd28](https://github.com/atom-ide-community/atom-script/commit/da8cd2827598385d55a35d0cca272dee90943ae9))
* fix the Doc exports ([49d165c](https://github.com/atom-ide-community/atom-script/commit/49d165c5844465a436fffa0d58cc3b7e9f9f0919))
* fix the Fortran exports ([d4f1b58](https://github.com/atom-ide-community/atom-script/commit/d4f1b585ece6594905628403e4ef965f76c89972))
* fix the Haskell exports ([6a64fff](https://github.com/atom-ide-community/atom-script/commit/6a64fffca11db8e699efe698479ca647bcb102a8))
* fix the JavaScript exports ([1e7e9d8](https://github.com/atom-ide-community/atom-script/commit/1e7e9d85f8e43b3c9dd91c28eff0f590551a59a3))
* fix the Lua exports ([c1db695](https://github.com/atom-ide-community/atom-script/commit/c1db695b208b3fb5cc1c562af97d759f66d2a102))
* fix the Perl exports ([2affb98](https://github.com/atom-ide-community/atom-script/commit/2affb986b63433608719ff1a7ccd19218b68b7d2))
* fix the Python exports ([2ace5e6](https://github.com/atom-ide-community/atom-script/commit/2ace5e65a2562fe0c6b7a10eea154e65f8bcece8))
* fix the ShellGrammars exports ([a532457](https://github.com/atom-ide-community/atom-script/commit/a5324575938484486409e44a2ab799d84355a572))
* fix the Windows exports ([7db731d](https://github.com/atom-ide-community/atom-script/commit/7db731d2a217c20ee20886a868d9a734bcc308c9))
* in C - inline switch-case + add default case ([ff1fe86](https://github.com/atom-ide-community/atom-script/commit/ff1fe86f8e37cc544eb285fc8184ffbfac3ed056))
* remove guards because of workingDirectory ([26b5e53](https://github.com/atom-ide-community/atom-script/commit/26b5e531fef5a63de3ebdb51bfb5cd94a3ac472b))
* scopeName not defined ([45ed16d](https://github.com/atom-ide-community/atom-script/commit/45ed16de249abe58b0bfd9ba0f722b6ded621a2a))
* the coffee file imports ([b746e93](https://github.com/atom-ide-community/atom-script/commit/b746e9352642d2bb6b127af949fb4a81f14d8394))


### Features

* decaffeinate ([2056c30](https://github.com/atom-ide-community/atom-script/commit/2056c30ba132efd4cb4d09acdb804f347482c480))

# [3.30.0](https://github.com/atom-ide-community/atom-script/compare/v3.29.6...v3.30.0) (2021-03-21)


### Bug Fixes

* remove unused variable ([822bfcb](https://github.com/atom-ide-community/atom-script/commit/822bfcbb696d44db9749dcc1ae60e8115bd9155c))
* use multi-line literal instead of concatenation ([e23e2ab](https://github.com/atom-ide-community/atom-script/commit/e23e2abab02e62c1e66e233abccacd62ba1c49d2))
* use parameters directly as config options ([e21cd59](https://github.com/atom-ide-community/atom-script/commit/e21cd5983d2a458c07b50106f95b5080ee7cae37))


### Features

* make position of output panel configurable ([004525a](https://github.com/atom-ide-community/atom-script/commit/004525a03a510046410ece45ec936abcf5f2ac2c))

## [3.29.6](https://github.com/atom-ide-community/atom-script/compare/v3.29.5...v3.29.6) (2021-03-21)


### Bug Fixes

* es6 export in garammars/javascript ([531a015](https://github.com/atom-ide-community/atom-script/commit/531a015f88714c167b3b1f524d696a7a3298d387))
* eslint fix ([e5b807d](https://github.com/atom-ide-community/atom-script/commit/e5b807d91e47528f8d213d9db581123c3db7746a))
* export entry functions directly ([9783277](https://github.com/atom-ide-community/atom-script/commit/97832771c6e3cf9a1f2943ba2e128d4c720bb067))
* update dependencies ([7dc0e3d](https://github.com/atom-ide-community/atom-script/commit/7dc0e3d2cd6476fede46c436cb0f71ef180fa718))

## [3.29.5](https://github.com/atom-ide-community/atom-script/compare/v3.29.4...v3.29.5) (2021-03-21)


### Bug Fixes

* try catch toHtml ([b9cd891](https://github.com/atom-ide-community/atom-script/commit/b9cd89128dd207045b84461b01aaf663b03e4a5c))

## [3.29.4](https://github.com/atom-ide-community/atom-script/compare/v3.29.3...v3.29.4) (2021-03-21)


### Bug Fixes

* if arg is not string assign it ([f7f591e](https://github.com/atom-ide-community/atom-script/commit/f7f591e2fc7c89bf63cd1bb9cdd01fb113bfbd59))

## [3.29.3](https://github.com/atom-ide-community/atom-script/compare/v3.29.2...v3.29.3) (2020-12-30)


### Bug Fixes

* add activation hook to defer the package's loading ([985bd4e](https://github.com/atom-ide-community/atom-script/commit/985bd4e5c7e83819dc81f7a10873691b756571ca))

## [3.29.2](https://github.com/atom-ide-community/atom-script/compare/v3.29.1...v3.29.2) (2020-12-30)


### Bug Fixes

* eslint --fix ([095d03c](https://github.com/atom-ide-community/atom-script/commit/095d03c3cbe01370de7e04f83553e75aebc393ca))
* update eslint ([5754954](https://github.com/atom-ide-community/atom-script/commit/5754954bab62c7b2ef2b57536bcbd2fdfa2549ff))

## [3.29.1](https://github.com/atom-ide-community/atom-script/compare/v3.29.0...v3.29.1) (2020-12-30)


### Bug Fixes

* update dependencies ([c898a92](https://github.com/atom-ide-community/atom-script/commit/c898a929f64da2b20809f2f12ad37afe69a1ab63))

# [3.29.0](https://github.com/atom-ide-community/atom-script/compare/v3.28.0...v3.29.0) (2020-12-30)


### Bug Fixes

* add @babel/preset-react to support JSX ([4390c94](https://github.com/atom-ide-community/atom-script/commit/4390c94d143ad2ca4cb323e18f901beff4f216ca))
* add babelConfig using @babel/preset-env ([c9f3aae](https://github.com/atom-ide-community/atom-script/commit/c9f3aae5cb4dc859db0554d0d67c8213574f4f48))
* move [@babel](https://github.com/babel) packages to the deps ([e362aae](https://github.com/atom-ide-community/atom-script/commit/e362aaebfec6b8a93d4cd88cc45dc4e7183fdc89))
* resolve to babel exe based on the OS ([2b8bcd0](https://github.com/atom-ide-community/atom-script/commit/2b8bcd0818b38592c3af3b9397136355f2aee08e))
* use babel in coffeescript ([a7d48ff](https://github.com/atom-ide-community/atom-script/commit/a7d48ff34caaf5b7fdef9980404113b3fa0251c2))


### Features

* switch to `[@babel](https://github.com/babel)` packages ([88e8aef](https://github.com/atom-ide-community/atom-script/commit/88e8aefc7ddbb03bcbde834547cda94e0fbb9d12))

# [3.28.0](https://github.com/atom-ide-community/atom-script/compare/v3.27.1...v3.28.0) (2020-12-30)


### Features

* use atom-space-pen-views-plus ([f5042b8](https://github.com/atom-ide-community/atom-script/commit/f5042b8f00cbe088749a95a5add4054d0ad4ced5))

## [3.27.1](https://github.com/atom-ide-community/atom-script/compare/v3.27.0...v3.27.1) (2020-12-29)


### Bug Fixes

* update uuid to v8 ([446e4bc](https://github.com/atom-ide-community/atom-script/commit/446e4bcf0ae4775077f9810952263277b4350770))

## 3.27.0
* Renamed Perl6 to Raku
* Support for ConTeXt MkIV and LMTX
* Run the tests on all platforms

## 3.15.0

* Improved documentation
* JSX now handled by node
* C++ Grammar supports C++14 now too
* Selection based support for C++ on macOS
* added selection based code execution for C++ & C++14 in macOS
* :new: support for Idris, Fable, Bats, Lisp, Turing
* improved Java support

## 3.14.1

* Fix exception occuring during closing of output panel

## 3.14.0

* Support for `PureScript`
* Support for `Robot Framework`
* Fix exception in options view

## 3.13.0

* Support for `HTML`
* Fix exception during profile saving

## 3.12.2

* Fix condition for detecting cwd.

## 3.12.1

* Fix `Cannot read property 'path' of undefined`

## 3.12.0

* Convert codebase to ES6 Javascript
* Fix path to fixtures in tests
* Support for `LAMMPS`
* Support for `VBScript`

## 3.11.1

* Revert `Support java packages`

## 3.11.0

* Add ability to set how `current working directory` is calculated. See the package settings!
* Support for `Ren'py`
* Add a dummy runner for generic `SQL`
* Support `c++14` standard for `c++`
* Support `java` packages
* Use `ts-node` as `typescript` runner
* Tune `F*` run
* Fix `MIPS` file-based run

## 3.10.1

* Fix `tsc` run

## 3.10.0

* Support for `BuckleScript`
* Support for `F*`
* Support for `Hy`
* Support for `MIPS`
* Support for `Oz`
* Ignore first line check in scripts on Windows
* Fix the `{FILE_ACTIVE_NAME_BASE}}` doesn't work
* Fix run `tsc` on non amd or system module types

## 3.9.0

* Support "Selection Based" run for `C#`
* Support "Selection Based" run for `C# Script`
* Support "Selection Based" run for `C`
* Support "Selection Based" run for `C++`
* Support "Selection Based" run for `D`
* Support "Selection Based" run for `Dart`
* Support "Selection Based" run for `DOT (Graphviz)`
* Support "Selection Based" run for `Powershell`
* Fix `MATLAB` plot support
* Fix #973 (`args.split is not a function`)

## 3.8.3

* Support for Processing

## 3.8.2

* Support for Lua (WoW)

## 3.8.1

* Fix compilation errors

## 3.8.0

* Support for C/C++ on Windows (only latest win10 builds with `bash` and `g++` installed)
* Support for Fortran
* Support for `Inno Setup`
* Support for Tcl
* Use `cmd.exe` for `Batch` files
* Change `stata` intrepreter to `stata`

## 3.7.3

* Support for Stata
* Support for MATLAB

## 3.7.2

* Support Rust on Windows

## 3.7.1

* Support for Ansible playbooks

## 3.7.0

* Adapt script for tests in go
* Support Jolie language
* Keep Java runner within same console on Windows
* Option to ignore selection runs
* Fix C++ not running on Linux
* Fix OCaml support

## 3.6.3

* Fix bug prevents the package from disabling and updating

## 3.6.2

* Fix running of atom://config files

## 3.6.1

* Fix bug prevents the package from loading

## 3.6.0

* Support ioLanguage
* Ability to set working directory
* File based prolog command runs swipl from file directory
* Templated args support

## 3.5.2

* Support `LaTeX Beamer`

## 3.5.1

* Temporarily remove a `Cake[file]` support cause of bugs

## 3.5.0

* Visual updates to the options view
* Support prolog
* Support `Cake[file]`
* Improved selection based support for Perl
* Small bug fixes all over
* We promise to lint and have some sanity around :coffee:script
* New profiles mode!

## 3.0.2

* Fix when stdin is coming on in (still doesn't accept it, but it also doesn't act wild)
* JXA language support fixed
* Support for Postgres
* Selection based support for Octave

## 3.0.1

* Quick doc updates

## 3.0.0

* Support for Dart
* Support for Nim/Nimscript
* Support for JXA (OS X - JavaScript for Automation)
* Selection support for NSIS
* Major refactor of runs - let us know how it goes
* File paths get wrapped as links

## 2.29.0

* Really 2.28.0 again, can't seem to delete failed releases on atom.io

## 2.28.0
* Add Nim support
* Add Pandoc Markdown support
* Upgrade strip ANSI

## 2.27.0
* Crystal Language support
* LaTeX support
* NSIS support
* Scrolls down in a polling loop to catch the reflow!
* No more grandparent bottom panel

## 2.26.4
* Fix Babel support
* Now with TypeScript!
* Sometimes I really wish this was in ES6, not CoffeeScript (https://gist.github.com/rgbkrk/91b40941a38daf700e61)

## 2.26.3
* Support for NCL

## 2.26.2
* Escape strings for javac

## 2.26.1
* Support for C based runner on Linux

## 2.26.0
* Make height of atom script view dynamic
* No one reads these. If they did, they might have commented on this line.

## 2.25.3
* Fix C/C++ grammar to allow symbols and spaces in path

## 2.25.2
* Support for MongoDB JavaScript
* More unicorns, less turtles

## 2.25.1
* Fix typo in Perl 6 Grammar

## 2.25.0
* Behat support no longer uses `--ansi` parameter (support Behat 3)
* Perl 6 support
* Graphviz support

## 2.24.0
* RANT Support
* Switched to using activation commands
* Cleaned up kotlinc temp files
* (Slight) support for Java
* Babel JS support

## 2.23.0
* Added scriptcs support

## 2.22.0
* Removed support for Atom Achievements :( (breaks the coming 1.0 API)
* Support for Kotlinc
* New way for us to manage contributions and changelog

## 2.21.0
* Update BufferedProcess API
* Addressed deprecations from the Atom API
* Use the new Path API

## 2.20.0
* Add OCaml support
* :checkered_flag: Enhance selection based Lua support

## 2.19.0
* Add Racket support
* Add Forth support

## 2.18.0
* Fixed scrolling with output

## 2.17.1
* Updates keyboard shortcuts for running in Windows

## 2.17.0
* TODO...

## 2.16.0
* Add D support
* Add Rust support
* Fix broken ANSI/HTML escaping [#238](https://github.com/atom-ide-community/atom-script/issues/238)
* Turn on colored diagnostics for the C language family

## 2.15.1
* Remove a unused import from script.less

## 2.15.0
* Add temporary file support
* Enhance PHP selection based runner

## 2.14.0
* Add the ability to unescape HTML output (configuration option)
* Add total execution time to output (configuration option)
* Update Shell Script grammar name
* Update PowerShell runner to support files with whitespace in the name

## 2.13.0
* Add Sass support
* Add SCSS support

## 2.12.1
* Update the LiveScript command to `lsc` vs. `livescript`. Since [v1.1.0](http://livescript.net/blog/livescript-1.1.0.html) `lsc` was previously available as an alias and now the official command to run code.

## 2.12.0
* Add SML support
* Add the OperatingSystem grammar utils for platform specific run code
* Add Mac OS X specific C, C++, Objective-C, and Objective-C++ file based runs

## 2.11.2
* Incidental release -- no new changes

## 2.11.1
* Rename "Line Based runs" to "Line Number Based runs"

## 2.11.0
* Add Batch support

## 2.10.1
* Update LiveScript to use newer grammar mapping

## 2.10.0
* Fix Swift against Xcode Beta 5

## 2.9.0
* Add LilyPond support
* Add "Ruby on Rails" support
* Add Makefile support
* Now handling shebangs!

## 2.8.0
* Add Swift support
* Add PowerShell support

## 2.7.0
* The escape key will now close the script output pane
* More tests, because this project definitely needs more tests
* Support for MoonScript

## 2.6.0
* Added line based support
* Updated a few BDD/TDD grammars with line based support
* Improved selection support by correcting the line numbers
* Travis CI and specs added

## 2.5.0
* Added LiveScript support
* Keybindings for Linux and Windows!
* Almost made shift-enter a keybinding for running code

## 2.4.0
* Accept shift-enter as another keymap for run
* Added Scheme support (guile as default)

## 2.3.8
* Added AppleScript support

## 2.3.7
* Added IcedCoffeeScript support

## 2.3.6
* Added R support

## 2.3.5
* Use colored output for TDD related grammars by default
* Improved selection support

## 2.3.4
* Fixed copy paste in options dialog

## 2.3.3
* Added Behat support

## 2.3.2
* Allow for different commands per run-mode
* Massive CoffeeScript cleanups
* Saves file prior to run

## 2.3.1
* Support for RSpec (file based)
* Support for Gherkin/Cucumber (file based)

## 2.3.0
* Support for Literate CoffeeScript
* New drop down for argument, command, and current working directory choices

## 2.2.0
* Catch spawn errors, present debug information for the user

## 2.1.8
* Add Lua support

## 2.1.7
* Escape HTML output while still letting ANSI colors through (#80)
* Add PHP example

## 2.1.6
* Allow copying text from the terminal output.

## 2.1.0-2.1.5
* Added Julia support
* Added Erlang support (selection based)
* Added Groovy support
* Added Scala support

## 2.0.4
* Added file based Haskell support

## 2.0.3
* Escaped ANSI to HTML
* Added contributors to package.json

## 2.0.1-2.0.2
* Documentation patches

## 2.0.0
- Completely new UI
- Status indicators / icons for script run, stop, kill, complete
- Updated commands to kill process and dismiss script view
- Added close button for script view
- Added language support for Go, F#, newLisp
