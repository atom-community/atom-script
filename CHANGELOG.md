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
