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
* Fix broken ANSI/HTML escaping [#238](https://github.com/rgbkrk/atom-script/issues/238)
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
