# Script

[![Build Status](http://img.shields.io/travis/rgbkrk/atom-script.svg?style=flat)](https://travis-ci.org/rgbkrk/atom-script)

**Run code in Atom!**

Run scripts based on file name, a selection of code, or by line number.

![](https://cloud.githubusercontent.com/assets/1694055/3226201/c458acbc-f067-11e3-84a0-da27fe334f5e.gif)

Currently supported grammars are:

| Grammar                             | File Based | Selection Based | Required Package              | Required in [`PATH`]      | Notes                                                                                                                                                                                                                                                           |
|:------------------------------------|:-----------|:----------------|:------------------------------|:--------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1C (BSL)                            | Yes        |                 | [language-1c-bsl]             | [`oscript`]               |                                                                                                                                                                                                                                                                 |
| [Ansible]                           | Yes        |                 | [language-ansible]            | `ansible-playbook`        |                                                                                                                                                                                                                                                                 |
| [AutoHotKey]                        | Yes        | Yes             | [language-autohotkey]         | `AutoHotKey.exe`          |                                                                                                                                                                                                                                                                 |
| [AppleScript]                       | Yes        | Yes             | [language-applescript]        | `osascript`               |                                                                                                                                                                                                                                                                 |
| [Babel] [ES6] JS                    | Yes        | Yes             | [language-babel]              | `node`                    |                                                                                                                                                                                                                                                                 |
| Bash                                | Yes        | Yes             |                               |                           | Runs if your `SHELL` or `#!` line is `bash`.                                                                                                                                                                                                                    |
| [Bats] (Bash Automated Test System) | Yes        | Yes             | [language-bats]               | `bats`                    |                                                                                                                                                                                                                                                                 |
| Windows [Batch] (`cmd.exe`)         | Yes        |                 | [language-batch]/[file]       |                           |                                                                                                                                                                                                                                                                 |
| [Behat]                             | Yes        |                 | [behat-atom]                  | `behat`                   |                                                                                                                                                                                                                                                                 |
| [BuckleScript]                      | Yes        | Yes             | [bs-platform]                 | `bsc`                     |                                                                                                                                                                                                                                                                 |
| C                                   | Yes        | Yes             |                               | `xcrun clang`/`cc`        | Available only on macOS and Linux.                                                                                                                                                                                                                              |
| C#                                  | Yes        | Yes             |                               | `csc.exe`                 |                                                                                                                                                                                                                                                                 |
| [C# Script]                         | Yes        | Yes             |                               | [`scriptcs`]              |                                                                                                                                                                                                                                                                 |
| C++                                 | Yes        | Yes             |                               | `xcrun clang++`/`g++`     | Available only on macOS and Linux. Run with `-std=c++14`.                                                                                                                                                                                                       |
| [Clojure]                           | Yes        | Yes             |                               | `lein exec`               | Requires [Leiningen] with the [lein-exec] plugin.                                                                                                                                                                                                               |
| [CoffeeScript] ([Literate])         | Yes        | Yes             |                               | `coffee`                  |                                                                                                                                                                                                                                                                 |
| [Crystal]                           | Yes        | Yes             | [language-crystal-actual]     | `crystal`                 |                                                                                                                                                                                                                                                                 |
| [Cucumber] ([Gherkin])              | Yes        |                 | [language-gherkin]            | `cucumber`                |                                                                                                                                                                                                                                                                 |
| [D]                                 | Yes        | Yes             | [language-d]                  | `rdmd`                    |                                                                                                                                                                                                                                                                 |
| [Dart]                              | Yes        | Yes             | [dartlang]                    | `dart`                    |                                                                                                                                                                                                                                                                 |
| [DOT] ([Graphviz])                  | Yes        | Yes             | [language-dot]                | `dot`                     |                                                                                                                                                                                                                                                                 |
| [Elixir]                            | Yes        | Yes             | [language-elixir]             | `elixir`                  |                                                                                                                                                                                                                                                                 |
| [Erlang]                            |            | Yes             | [language-erlang]             | `erl`                     | Limited selection based runs only (see [#70]).                                                                                                                                                                                                                  |
| [F*]                                | Yes        |                 | [atom-fstar]                  | `fstar`                   |                                                                                                                                                                                                                                                                 |
| [F#]                                | Yes        |                 | [language-fsharp]             | `fsharpi`/`fsi.exe`       |                                                                                                                                                                                                                                                                 |
| [Fish]                              | Yes        | Yes             | [language-fish-shell]         | `fish`                    |                                                                                                                                                                                                                                                                 |
| [Forth]                             | Yes        |                 | [language-forth]              | `gforth`                  |                                                                                                                                                                                                                                                                 |
| [Fortran]                           | Yes        |                 | [language-fortran]            | [`gfortran`]              |                                                                                                                                                                                                                                                                 |
| [Gnuplot]                           | Yes        |                 | [language-gnuplot-atom]       | `gnuplot`                 |                                                                                                                                                                                                                                                                 |
| [Go]                                | Yes        |                 |                               | `go`                      |                                                                                                                                                                                                                                                                 |
| [Groovy]                            | Yes        | Yes             | [language-groovy]             | `groovy`                  |                                                                                                                                                                                                                                                                 |
| [Haskell] ([Literate][lit-hskl])    | Yes        | Yes             | [language-haskell]            | `runhaskell`/[`ghc`]      |                                                                                                                                                                                                                                                                 |
| HTML                                | Yes        |                 |                               |                           | Opens the current HTML file in your default browser.                                                                                                                                                                                                            |
| [Hy]                                | Yes        | Yes             | [language-hy]                 | `hy.exe`                  |                                                                                                                                                                                                                                                                 |
| [IcedCoffeeScript]                  | Yes        | Yes             | [language-iced-coffee-script] | `iced`                    |                                                                                                                                                                                                                                                                 |
| [Inno Setup]                        | Yes        |                 | [language-innosetup]          | `ISCC.exe`                |                                                                                                                                                                                                                                                                 |
| [Idris]                             | Yes        |                 | [language-idris]              | `idris`                   |                                                                                                                                                                                                                                                                 |
| [io]                                | Yes        | Yes             | [atom-language-io]            | `io`                      |                                                                                                                                                                                                                                                                 |
| Java                                | Yes        |                 |                               | `*\jdk1.x.x_xx\bin`       | Project directory should be the source directory; subfolders imply packaging.                                                                                                                                                                                   |
| Javascript                          | Yes        | Yes             |                               | `node`                    |                                                                                                                                                                                                                                                                 |
| JavaScript for Automation ([JXA])   | Yes        | Yes             | [language-javascript-jxa]     | `osascript -l JavaScript` | Available on macOS only.                                                                                                                                                                                                                                        |
| [Jolie]                             | Yes        |                 | [language-jolie]              | `jolie`                   |                                                                                                                                                                                                                                                                 |
| [Julia]                             | Yes        | Yes             | [language-julia]              | `julia`                   |                                                                                                                                                                                                                                                                 |
| [Kotlin]                            | Yes        | Yes             | [language-kotlin]             | `kotlinc`                 |                                                                                                                                                                                                                                                                 |
| [LAMMPS]                            | Yes        |                 | [language-lammps]             | `lammps`                  | Available only on macOS and Linux.                                                                                                                                                                                                                              |
| [LaTeX]                             | Yes        |                 | [language-latex]              | [`latexmk`]               |                                                                                                                                                                                                                                                                 |
| [LilyPond]                          | Yes        |                 | [atlilypond]                  | `lilypond`                |                                                                                                                                                                                                                                                                 |
| [Lisp]                              | Yes        | Yes             | [language-lisp]               | [`sbcl`]                  | Selection based runs are limited to a single line.                                                                                                                                                                                                              |
| [LiveScript]                        | Yes        | Yes             | [language-livescript]         | `lsc`                     |                                                                                                                                                                                                                                                                 |
| [Lua]                               | Yes        | Yes             | [language-lua]\[[-wow]\]      | `lua`                     |                                                                                                                                                                                                                                                                 |
| [Make]file                          | Yes        | Yes             |                               |                           |                                                                                                                                                                                                                                                                 |
| [MATLAB]                            | Yes        | Yes             | [language-matlab]             | `matlab`                  |                                                                                                                                                                                                                                                                 |
| [MIPS]                              | Yes        |                 | [language-mips]               | [`spim`]                  |                                                                                                                                                                                                                                                                 |
| [MongoDB]                           | Yes        | Yes             | [language-mongodb]            | `mongo`                   |                                                                                                                                                                                                                                                                 |
| [MoonScript]                        | Yes        | Yes             | [language-moonscript]         | `moon`                    |                                                                                                                                                                                                                                                                 |
| [NCL]                               | Yes        | Yes             | [language-ncl]                | `ncl`                     | Scripts must end with an `exit` command for file based runs.                                                                                                                                                                                                    |
| [newLISP]                           | Yes        | Yes             | [language-newlisp]            | `newlisp`                 |                                                                                                                                                                                                                                                                 |
| [Nim]\[[Script][nimscript]\]        | Yes        |                 | [language-nim]                | `nim`                     |                                                                                                                                                                                                                                                                 |
| [NSIS]                              | Yes        | Yes             | [language-nsis]               | `makensis`                |                                                                                                                                                                                                                                                                 |
| Objective-C[++]                     | Yes        |                 |                               | `xcrun clang`[`++`]       | Available on macOS only.                                                                                                                                                                                                                                        |
| [OCaml]                             | Yes        |                 | [language-ocaml]              | `ocaml`                   |                                                                                                                                                                                                                                                                 |
| [Octave]                            | Yes        | Yes             | [language-matlab]             | `octave`                  |                                                                                                                                                                                                                                                                 |
| [Oz]                                | Yes        | Yes             | [language-oz]                 | `ozc`                     |                                                                                                                                                                                                                                                                 |
| [Pandoc] Markdown                   | Yes        |                 | [language-pfm]                | [`panzer`]                |                                                                                                                                                                                                                                                                 |
| [Pascal]                            | Yes        | Yes             | [language-pascal]             | `fsc`                     |                                                                                                                                                                                                                                                                 |
| Perl                                | Yes        | Yes             |                               |                           |                                                                                                                                                                                                                                                                 |
| [Perl 6]                            | Yes        | Yes             |                               | `perl6`                   |                                                                                                                                                                                                                                                                 |
| PHP                                 | Yes        | Yes             |                               |                           |                                                                                                                                                                                                                                                                 |
| [PostgreSQL]                        | Yes        | Yes             | [language-pgsql]              | [`psql`]                  | Connects as user `PGUSER` to database `PGDATABASE`. Both default to your operating system's `USERNAME`, but can be set in the process environment or in Atom's [`init` file]: `process.env.PGUSER = {user name}` and `process.env.PGDATABASE = {database name}` |
| [PowerShell]                        | Yes        | Yes             | [language-powershell]         | `powershell`              |                                                                                                                                                                                                                                                                 |
| [Processing]                        | Yes        |                 | [processing-language]         | `processing-java`         |                                                                                                                                                                                                                                                                 |
| [Prolog]                            | Yes        |                 | [language-prolog]             | `swipl`                   | Scripts must contain a rule with the head `main` (e.g.`main:- parent(X,lucas),writeln(X).`). The script is executed with the goal `main` and exits after the first result is found. The output is produced by the `writeln/1` predicates.                       |
| [PureScript]                        | Yes        |                 | [language-purescript]         | `pulp`                    |                                                                                                                                                                                                                                                                 |
| Python                              | Yes        | Yes             |                               |                           |                                                                                                                                                                                                                                                                 |
| [R]                                 | Yes        | Yes             | [language-r]                  | `Rscript`                 |                                                                                                                                                                                                                                                                 |
| [Racket]                            | Yes        | Yes             | [language-racket]             | `racket`                  |                                                                                                                                                                                                                                                                 |
| [Reason]                            | Yes        | Yes             | [language-reason]             | `rebuild`                 |                                                                                                                                                                                                                                                                 |
| [Ren'Py]                            | Yes        | No              | [language-renpy]              | `renpy`                   | Runs your project at the root of the current file.                                                                                                                                                                                                              |
| [Robot Framework]                   | Yes        | No              | [language-robot-framework]    | `robot`                   | The output location depends on the `CWD` behaviour which can be altered in settings.                                                                                                                                                                            |
| [RSpec]                             | Yes        | Yes             | [language-rspec]              | `rspec`                   |                                                                                                                                                                                                                                                                 |
| Ruby                                | Yes        | Yes             |                               |                           |                                                                                                                                                                                                                                                                 |
| Ruby on [Rails]                     | Yes        | Yes             |                               |                           |                                                                                                                                                                                                                                                                 |
| [Rust]                              | Yes        |                 | [language-rust]               | `rustc`                   |                                                                                                                                                                                                                                                                 |
| [Sage]                              | Yes        | Yes             | [language-sage]               | `sage`                    |                                                                                                                                                                                                                                                                 |
| [Sass]/SCSS                         | Yes        |                 |                               | `sass`                    |                                                                                                                                                                                                                                                                 |
| [Scala]                             | Yes        | Yes             | [language-scala]              | `scala`                   |                                                                                                                                                                                                                                                                 |
| [Scheme]                            | Yes        | Yes             | [langauge-scheme]             | [`guile`]                 |                                                                                                                                                                                                                                                                 |
| Shell Script                        | Yes        | Yes             |                               | `SHELL`                   | Runs according to your default `SHELL`, or `#!` line.                                                                                                                                                                                                           |
| [Standard ML]                       | Yes        |                 | [language-sml]                | `sml`                     |                                                                                                                                                                                                                                                                 |
| [Stata]                             | Yes        | Yes             | [language-stata]              | `stata`                   |                                                                                                                                                                                                                                                                 |
| [Swift]                             | Yes        |                 | [language-swift]              | `swift`                   |                                                                                                                                                                                                                                                                 |
| [Tcl]                               | Yes        | Yes             | [language-tcltk]              | `tclsh`                   |                                                                                                                                                                                                                                                                 |
| [TypeScript]                        | Yes        | Yes             |                               | [`ts-node`]               |                                                                                                                                                                                                                                                                 |
| [VBScript]                          | Yes        | Yes             | [language-vbscript]           | `cscript`                 |                                                                                                                                                                                                                                                                 |
| [Zsh]                               | Yes        | Yes             |                               |                           | Runs if your `SHELL` or `#!` line is `zsh`.                                                                                                                                                                                                                     |

[-wow]:                         https://atom.io/packages/language-lua-wow
[#70]:                          https://github.com/rgbkrk/atom-script/pull/70
[`gfortran`]:                   https://gcc.gnu.org/wiki/GFortran
[`ghc`]:                        https://haskell.org/ghc
[`guile`]:                      https://gnu.org/software/guile
[`init` file]:                  http://flight-manual.atom.io/hacking-atom/sections/the-init-file
[`latexmk`]:                    https://ctan.org/pkg/latexmk
[`oscript`]:                    http://oscript.io
[`panzer`]:                     https://github.com/msprev/panzer#readme
[`PATH`]:                       https://en.wikipedia.org/wiki/PATH_(variable)
[`psql`]:                       https://postgresql.org/docs/current/static/app-psql.html
[`pulp`]:                       https://github.com/purescript-contrib/pulp#readme
[`sbcl`]:                       http://sbcl.org
[`scriptcs`]:                   http://scriptcs.net
[`spim`]:                       http://spimsimulator.sourceforge.net
[`ts-node`]:                    https://github.com/TypeStrong/ts-node#readme
[Ansible]:                      https://ansible.com
[AppleScript]:                  https://developer.apple.com/library/content/documentation/AppleScript/Conceptual/AppleScriptX/Concepts/ScriptingOnOSX.html#//apple_ref/doc/uid/20000032-BABEBGCF
[atlilypond]:                   https://atom.io/packages/atlilypond
[atom-fstar]:                   https://github.com/FStarLang/atom-fstar#readme
[atom-language-io]:             https://atom.io/packages/atom-language-io
[AutoHotKey]:                   https://autohotkey.com
[babel]:                        https://babeljs.io
[batch]:                        https://ss64.com/nt
[bats]:                         https://github.com/sstephenson/bats#bats-bash-automated-testing-system#readme
[behat-atom]:                   https://atom.io/packages/behat-atom
[behat]:                        http://docs.behat.org/en/v2.5/guides/6.cli.html
[bs-platform]:                  https://npm.im/package/bs-platform
[bucklescript]:                 https://bucklescript.github.io/bucklescript
[C# Script]:                    http://csscript.net
[clojure]:                      https://clojure.org
[coffeescript]:                 http://coffeescript.org
[crystal]:                      https://crystal-lang.org
[cucumber]:                     https://cucumber.io
[D]:                            https://dlang.org
[dart]:                         https://dartlang.org
[dartlang]:                     https://atom.io/packages/dartlang
[dot]:                          http://graphviz.org/content/dot-language
[elixir]:                       https://elixir-lang.org
[erlang]:                       https://erlang.org
[ES6]:                          https://babeljs.io/learn-es2015
[F*]:                           https://fstar-lang.org
[F#]:                           http://fsharp.org
[file]:                         https://atom.io/packages/language-batchfile
[fish]:                         https://fishshell.com
[forth]:                        https://gnu.org/software/gforth
[fortran]:                      http://fortranwiki.org/fortran/show/Fortran
[gherkin]:                      https://cucumber.io/docs/reference#gherkin
[gnuplot]:                      http://gnuplot.info
[go]:                           https://golang.org
[graphviz]:                     http://graphviz.org
[groovy]:                       http://groovy-lang.org
[haskell]:                      https://haskell.org
[hy]:                           http://hylang.org
[icedcoffeescript]:             http://maxtaco.github.io/coffee-script
[idris]:                        https://idris-lang.org
[inno setup]:                   http://jrsoftware.org/isinfo.php
[io]:                           http://iolanguage.org
[jolie]:                        http://jolie-lang.org
[julia]:                        https://julialang.org
[jxa]:                          https://developer.apple.com/library/mac/releasenotes/InterapplicationCommunication/RN-JavaScriptForAutomation/Articles/Introduction.html
[kotlin]:                       https://kotlinlang.org
[LAMMPS]:                       http://lammps.sandia.gov
[langauge-scheme]:              https://atom.io/packages/language-scheme
[language-1c-bsl]:              https://atom.io/packages/language-1c-bsl
[language-ansible]:             https://atom.io/packages/language-ansible
[language-applescript]:         https://atom.io/packages/language-applescript
[language-autohotkey]:          https://atom.io/packages/language-autohotkey
[language-babel]:               https://atom.io/packages/language-babel
[language-batch]:               https://atom.io/packages/language-batch
[language-bats]:                https://atom.io/packages/language-bats
[language-crystal-actual]:      https://atom.io/packages/language-crystal-actual
[language-d]:                   https://atom.io/packages/language-d
[language-dot]:                 https://atom.io/packages/language-dot
[language-elixir]:              https://atom.io/packages/language-elixir
[language-erlang]:              https://atom.io/packages/language-erlang
[language-fish-shell]:          https://atom.io/packages/language-fish-shell
[language-forth]:               https://atom.io/packages/language-forth
[language-fortran]:             https://atom.io/packages/language-fortran
[language-fsharp]:              https://atom.io/packages/language-fsharp
[language-gherkin]:             https://atom.io/packages/language-gherkin
[language-gnuplot-atom]:        https://atom.io/packages/language-gnuplot-atom
[language-groovy]:              https://atom.io/packages/language-groovy
[language-haskell]:             https://atom.io/packages/language-haskell
[language-hy]:                  https://atom.io/packages/language-hy
[language-iced-coffee-script]:  https://atom.io/packages/language-iced-coffee-script
[language-idris]:               https://atom.io/packages/language-idris
[language-innosetup]:           https://atom.io/packages/language-innosetup
[language-javascript-jxa]:      https://atom.io/packages/language-javascript-jxa
[language-jolie]:               https://atom.io/packages/language-jolie
[language-julia]:               https://atom.io/packages/language-julia
[language-kotlin]:              https://atom.io/packages/language-kotlin
[language-lammps]:              https://atom.io/packages/language-lammps
[language-latex]:               https://atom.io/packages/language-latex
[language-lisp]:                https://atom.io/packages/language-lisp
[language-livescript]:          https://atom.io/packages/language-livescript
[language-lua]:                 https://atom.io/packages/language-lua
[language-matlab]:              https://atom.io/packages/language-matlab
[language-mips]:                https://atom.io/packages/language-mips
[language-mongodb]:             https://atom.io/packages/language-mongodb
[language-moonscript]:          https://atom.io/packages/language-moonscript
[language-ncl]:                 https://atom.io/packages/language-ncl
[language-newlisp]:             https://atom.io/packages/language-newlisp
[language-nim]:                 https://atom.io/packages/language-nim
[language-nsis]:                https://atom.io/packages/language-nsis
[language-ocaml]:               https://atom.io/packages/language-ocaml
[language-oz]:                  https://atom.io/packages/language-oz
[language-pascal]:              https://atom.io/packages/language-pascal
[language-pfm]:                 https://atom.io/packages/language-pfm
[language-pgsql]:               https://atom.io/packages/language-pgsql
[language-powershell]:          https://atom.io/packages/language-powershell
[language-prolog]:              https://atom.io/packages/language-prolog
[language-purescript]:          https://atom.io/packages/language-purescript
[language-r]:                   https://atom.io/packages/language-r
[language-racket]:              https://atom.io/packages/language-racket
[language-reason]:              https://atom.io/packages/language-reason
[language-renpy]:               https://atom.io/packages/language-renpy
[language-robot-framework]:     https://atom.io/packages/language-robot-framework
[language-rspec]:               https://atom.io/packages/language-rspec
[language-rust]:                https://atom.io/packages/language-rust
[language-sage]:                https://atom.io/packages/language-sage
[language-scala]:               https://atom.io/packages/language-scala
[language-sml]:                 https://atom.io/packages/language-sml
[language-stata]:               https://atom.io/packages/language-stata
[language-swift]:               https://atom.io/packages/language-swift
[language-tcltk]:               https://atom.io/packages/language-tcltk
[language-vbscript]:            https://atom.io/packages/language-vbscript
[latex]:                        https://latex-project.org
[lein-exec]:                    https://github.com/kumarshantanu/lein-exec#readme
[leiningen]:                    https://leiningen.org
[lilypond]:                     http://lilypond.org
[lisp]:                         http://lisp-lang.org
[lit-hskl]:                     https://wiki.haskell.org/Literate_programming#Haskell_and_literate_programming
[literate]:                     http://coffeescript.org/#literate
[livescript]:                   http://livescript.net
[lua]:                          https://lua.org
[make]:                         https://gnu.org/software/make/manual/make
[MATLAB]:                       https://mathworks.com/products/matlab
[mips]:                         https://imgtec.com/mips
[mongodb]:                      https://mongodb.com
[moonscript]:                   https://moonscript.org
[NCL]:                          https://ncl.ucar.edu
[newlisp]:                      http://newlisp.org
[nim]:                          https://nim-lang.org
[nimscript]:                    https://nim-lang.org/0.11.3/nims.html
[NSIS]:                         http://nsis.sourceforge.net
[ocaml]:                        https://ocaml.org
[octave]:                       https://gnu.org/software/octave
[oz]:                           https://mozart.github.io
[pandoc]:                       https://pandoc.org
[perl 6]:                       https://perl6.org
[pascal]:                       https://freepascal.org
[PostgreSQL]:                   https://postgresql.org
[powershell]:                   https://docs.microsoft.com/powershell
[processing-language]:          https://atom.io/packages/processing-language
[processing]:                   https://processing.org
[prolog]:                       http://swi-prolog.org
[purescript]:                   http://purescript.org
[R]:                            https://r-project.org
[racket]:                       https://racket-lang.org
[rails]:                        http://rubyonrails.org
[reason]:                       https://reasonml.github.io
[Ren'Py]:                       https://renpy.org
[robot framework]:              http://robotframework.org
[rspec]:                        http://rspec.info
[rust]:                         https://rust-lang.org
[sage]:                         https://sagemath.org
[sass]:                         http://sass-lang.com
[scala]:                        https://scala-lang.org
[scheme]:                       http://scheme-reports.org
[Standard ML]:                  http://sml-family.org
[stata]:                        https://stata.com
[swift]:                        https://swift.org
[tcl]:                          https://tcl.tk
[typescript]:                   https://typescriptlang.org
[VBScript]:                     https://msdn.microsoft.com/library/t0aew7h6.aspx
[zsh]:                          http://zsh.org

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

| Command                    | macOS                               | Linux/Windows               | Notes                                                                         |
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
