# Script

[![Build Status](http://img.shields.io/travis/rgbkrk/atom-script.svg?style=flat)](https://travis-ci.org/rgbkrk/atom-script)

**Run code in Atom!**

Run scripts based on file name, a selection of code, or by line number.

![](https://cloud.githubusercontent.com/assets/1694055/3226201/c458acbc-f067-11e3-84a0-da27fe334f5e.gif)

Currently supported grammars are:

| Grammar                              | File Based | Selection Based | Notes |
| :----------------------------------- | :--------- | :-------------- | :---- |
| 1C (BSL)                             | Yes        |                 | Runs through [OneScript](http://oscript.io/) interpreter in console mode |
| Ansible                              | Yes        |                 | |
| AutoHotKey                           | Yes        | Yes             | Requires the path of 'AutoHotKey.exe' in your system environment variables.
| AppleScript                          | Yes        | Yes             | |
| Babel ES6 JS                         | Yes        | Yes             | |
| Bash                                 | Yes        | Yes             | The shell used is based on your default `$SHELL` environment variable |
| Bash Automated Test System (Bats)    | Yes        | Yes             | |
| Batch                                | Yes        |                 | |
| Behat Feature                        | Yes        |                 | |
| BuckleScript                         | Yes        | Yes             | |
| C                                    | Yes        | Yes             | Only available on OSX (`xcrun clang`) and Linux (`cc`) |
| C#                                   | Yes        | Yes             | Requires the path of 'csc.exe' in your system environment variables |
| C# Script                            | Yes        | Yes             | |
| C++                                  | Yes        | Yes             | Requires `-std=c++14`. Only available on OSX (`xcrun clang++`) and Linux (`g++`) |
| Clojure                              | Yes        | Yes             | Clojure scripts are executed via [Leiningen](http://leiningen.org/)'s [exec](https://github.com/kumarshantanu/lein-exec) plugin. Both `Leiningen` and `exec` must be installed |
| CoffeeScript                         | Yes        | Yes             | |
| CoffeeScript (Literate)              | Yes        | Yes             | Running selections of code for CoffeeScript (Literate) only works when selecting just the code blocks |
| Crystal                              | Yes        | Yes             | |
| Cucumber (Gherkin)                   | Yes        |                 | |
| D                                    | Yes        | Yes             | |
| Dart                                 | Yes        | Yes             | |
| DOT (Graphviz)                       | Yes        | Yes             | |
| Elixir                               | Yes        | Yes             | |
| Erlang                               |            | Yes             | Uses `erl` for limited selection based runs (see [#70](https://github.com/rgbkrk/atom-script/pull/70)) |
| F#                                   | Yes        |                 | |
| F*                                   | Yes        |                 | |
| Fable                                | Yes        | Yes             | |
| Fish                                 | Yes        | Yes             | Finally, a way to run code within Atom for the 90s |
| Forth (via GForth)                   | Yes        |                 | |
| Fortran (via gfortran)               | Yes        |                 |
| Gnuplot                              | Yes        |                 | |
| Go                                   | Yes        |                 | |
| Groovy                               | Yes        | Yes             | |
| Haskell                              | Yes        | Yes             | |
| HTML                                 | Yes        |                 | Opens File in Browser |
| Hy                                   | Yes        | Yes             | Requires the path of 'hy.exe' in your system environment variables. This is probably already fulfilled if you used `pip install hy` to get Hy. A Hy grammar, such as [this one](https://atom.io/packages/language-hy) is also a good idea. |
| IcedCoffeeScript                     | Yes        | Yes             | |
| Inno Setup                           | Yes        |                 | Requires the path of `ISCC.exe` in your system environment variables |
| [Idris](http://idris-lang.org/)      | Yes        |                 | |
| [ioLanguage](http://iolanguage.org/) | Yes        | Yes             | |
| Java                                 | Yes        |                 | Windows users should manually add jdk path (...\jdk1.x.x_xx\bin) to their system environment variables. Project directory should be the source directory; subfolders imply packaging. |
| Javascript                           | Yes        | Yes             | |
| [JavaScript for Automation](https://developer.apple.com/library/mac/releasenotes/InterapplicationCommunication/RN-JavaScriptForAutomation/Articles/Introduction.html) (JXA)            | Yes        | Yes             | |
| Jolie                                | Yes        |                 | |
| Julia                                | Yes        | Yes             | |
| Kotlin                               | Yes        | Yes             | |
| LAMMPS                               | Yes        |                 | Only available on Linux and macOS. Requires 'lammps' to be in path. |
| LaTeX (via latexmk)                  | Yes        |                 | |
| LilyPond                             | Yes        |                 | |
| Lisp (via SBCL)                      | Yes        | Yes             | Selection based runs are limited to single line |
| Literate Haskell                     | Yes        |                 | |
| LiveScript                           | Yes        | Yes             | |
| Lua                                  | Yes        | Yes             | |
| Lua (WoW)                            | Yes        | Yes             | |
| Makefile                             | Yes        | Yes             | |
| [MATLAB](http://mathworks.com/products/matlab) | Yes        | Yes   | |
| MIPS                                 | Yes        |                 | Requires the path of `spim` in your system environment variables |
| MongoDB                              | Yes        | Yes             | |
| MoonScript                           | Yes        | Yes             | |
| [NCL](http://ncl.ucar.edu)           | Yes        | Yes             | Scripts must end with `exit` command for file based runs |
| newLISP                              | Yes        | Yes             | |
| Nim (and NimScript)                  | Yes        |                 | |
| NSIS                                 | Yes        | Yes             | |
| Objective-C                          | Yes        |                 | Only available on OSX (`xcrun clang`) |
| Objective-C                          | Yes        |                 | Only available on OSX (`xcrun clang++`) |
| OCaml                                | Yes        |                 | |
| Octave                               | Yes        | Yes             | |
| [Oz](https://mozart.github.io/)      | Yes        | Yes             | |
| Pandoc Markdown                      | Yes        |                 | Requires the panzer pandoc wrapper https://github.com/msprev/panzer and the pandoc-flavored-markdown language package in Atom https://atom.io/packages/language-pfm |
| Perl                                 | Yes        | Yes             | |
| Perl 6                               | Yes        | Yes             | |
| PHP                                  | Yes        | Yes             | |
| PostgreSQL                           | Yes        | Yes             | Requires the atom-language-pgsql package in Atom https://atom.io/packages/language-pgsql. Connects as user `$PGUSER` to database `$PGDATABASE`. Both default to the operating system's user name and both can be set in the process environment or in Atom's `init.coffee` script: `process.env.PGUSER = ⟨username⟩` and `process.env.PGDATABASE = ⟨database name⟩` |
| PowerShell                           | Yes        | Yes             | |
| Processing                           | Yes        |                 | Runs through processing-java. |
| Prolog                               | Yes        |                 | Scripts must contain a rule with the head `main` (e.g.`main:- parent(X,lucas),writeln(X).`). The script is executed with the goal `main` and is halted after the first result is found. The output is produced by the `writeln/1` predicates. It requires swipl |
| PureScript                           | Yes        |                 | Requires `pulp` to be in path. |
| Python                               | Yes        | Yes             | |
| R                                    | Yes        | Yes             | |
| Racket                               | Yes        | Yes             | |
| [RANT](https://github.com/TheBerkin/Rant) | Yes        | Yes             | |
| Reason                               | Yes        | Yes             | |
| Ren'Py                               | Yes        | No              | Requires `renpy` to be in path. Runs project at root of current file.|
| Robot Framework                      | Yes        | No              | Requires `robot` to be in path. Output location depends on CWD behaviour which can be altered in settings. |
| RSpec                                | Yes        | Yes             | |
| Ruby                                 | Yes        | Yes             | |
| Ruby on Rails                        | Yes        | Yes             | |
| Rust                                 | Yes        |                 | |
| Sage                                 | Yes        | Yes             | |
| Sass/SCSS                            | Yes        |                 | |
| Scala                                | Yes        | Yes             | |
| Scheme                               | Yes        | Yes             | |
| Shell Script                         | Yes        | Yes             | The shell used is based on your default `$SHELL` environment variable |
| Standard ML                          | Yes        |                 | |
| Stata                                | Yes        | Yes             | Runs through Stata. Note stata needs to be added to your system PATH for this to work. `Mac directions <http://www.stata.com/support/faqs/mac/advanced-topics/>`_ . |
| Swift                                | Yes        |                 | |
| Tcl                                  | Yes        | Yes             | |
| TypeScript                           | Yes        | Yes             | Requires `ts-node` https://github.com/TypeStrong/ts-node |
| VBScript                             | Yes        | Yes             | |
| Zsh                                  | Yes        | Yes             | The shell used is based on your default `$SHELL` environment variable |

**NOTE**: Some grammars may require you to install [a custom language package](https://atom.io/search?utf8=✓&q=language).

You only have to add a few lines in a PR to support another.

## Installation

`apm install script`

or

Search for `script` within package search in the Settings View.

## Atom can't find node | ruby | python | my socks

Make sure to launch Atom from the console/terminal. This gives atom all your useful environment variables. Additionally, make sure to run it with the project path you need. For example, use

```
atom .
```

to get it to run with the *current* directory as the default place to run scripts from.

If you *really* wish to open atom from a launcher/icon, see [this issue for a variety of workarounds that have been suggested](https://github.com/rgbkrk/atom-script/issues/61#issuecomment-37337827).

## Usage

Make sure to run `atom` from the command line to get full access to your environment variables. Running Atom from the icon will launch using launchctl's environment.

**Script: Run** will perform a "File Based" run when no text is selected (default).

**Script: Run** while text is selected will perform a "Selection Based" run executing just the highlighted code.

**Script: Run by Line Number** to run using the specified line number. **Note** that if you select an entire line this number could be off by one due to the way Atom detects numbers while text is selected.

**Script: Configure Script** should be used to configure command options, program arguments, and environment variables overrides. Environment variables may be input into the options view in the form `VARIABLE_NAME_ONE=value;VARIABLE_NAME_TWO="other value";VARIABLE_NAME_3='test'`.

Also, in this dialog you can save options as a profile for future use. For example, you can add two profiles, one for `python2.7` and another for `python3` and run scripts with a specified profile, which will be more convinient than entering options every time you want to switch python versions.

**Script: Run with profile** allows you to run scripts with saved profiles. Profiles can be added in **Script: Run Options** dialog.

**Script: Kill Process** will kill the process but leaves the pane open.

**Script: Close View** closes the pane and kills the process.

To kill everything, click the close icon in the upper right and just go back to
coding.

**Script: Copy Run Results** copies everything written to the output pane to the
clipboard, allowing you to paste it into the editor.

### Command and shortcut reference

| Command                    | Mac OS X                            | Linux/Windows               | Notes                                                                         |
|:---------------------------|:------------------------------------|:----------------------------|:------------------------------------------------------------------------------|
| Script: Run                | <kbd>cmd-i</kbd>                    | <kbd>shift-ctrl-b</kbd>     | If text is selected a "Selection Based" is used instead of a "File Based" run |
| Script: Run by Line Number | <kbd>shift-cmd-j</kbd>              | <kbd>shift-ctrl-j</kbd>     | If text is selected the line number will be the last                          |
| Script: Run Options        | <kbd>shift-cmd-i</kbd>              | <kbd>shift-ctrl-alt-o</kbd> | Runs the selection or whole file with the given options                       |
| Script: Run with profile   | <kbd>shift-cmd-k</kbd>              | <kbd>shift-ctrl-alt-b</kbd> | Runs the selection or whole file with the specified profile                   |
| Script: Close View         | <kbd>esc</kbd> or <kbd>ctrl-w</kbd> | <kbd>esc</kbd>              | Closes the script view window                                                 |
| Script: Kill Process       | <kbd>ctrl-c</kbd>                   | <kbd>ctrl-q</kbd>           | Kills the current script process                                              |

### Replacements

The following parameters will be replaced in any entry in `args` (command and program arguments). They should all be enclosed in curly brackets `{}`

  * `{FILE_ACTIVE}` - Full path to the currently active file in Atom. E.g. `/home/rgbkrk/atom-script/lib/script.coffee`
  * `{FILE_ACTIVE_PATH}` - Full path to the folder where the currently active file is. E.g. `/home/rgbkrk/atom-script/lib`
  * `{FILE_ACTIVE_NAME}` - Full name and extension of active file. E.g., `script.coffee`
  * `{FILE_ACTIVE_NAME_BASE}` - Name of active file WITHOUT extension. E.g., `script`
  * `{PROJECT_PATH}` - Full path to the root of the project. This is normally the path Atom has as root. E.g `/home/rgbkrk/atom-script`

Parameters are compatible with `atom-build` package.

## Development

This is an [Open Open Source Project](http://openopensource.org/), which means:

> Individuals making significant and valuable contributions are given commit-access to the project to contribute as they see fit.

As for coding and contributing, rely on the atom [contributing guidelines](https://atom.io/docs/latest/contributing).
They're pretty sane.

#### Quick and dirty setup

`apm develop script`

This will clone the `script` repository to `~/github` unless you set the
`ATOM_REPOS_HOME` environment variable.

#### I already cloned it!

If you cloned it somewhere else, you'll want to use `apm link --dev` within the
package directory, followed by `apm install` to get dependencies.

### Workflow

After pulling upstream changes, make sure to run `apm update`.

To start hacking, make sure to run `atom --dev` from the package directory.
Cut a branch while you're working then either submit a Pull Request when done
or when you want some feedback!
