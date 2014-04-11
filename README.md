# Run code in Atom!

![](https://f.cloud.github.com/assets/836375/2411158/34f05f36-aac4-11e3-95bb-76c6d49c9e9e.gif)

Run selections of code or the whole file!

Currently supports:

  * Bash
  * Coffeescript
  * CoffeeScript (Literate) <sup>^</sup>
  * Erlang <sup>†</sup>
  * Elixir
  * [Gherkin](https://atom.io/packages/cucumber) <sup>‡</sup><sup>*</sup>
  * Go <sup>*</sup>
  * Groovy
  * F# <sup>*</sup>
  * Haskell <sup>*</sup>
  * Javascript
  * Julia
  * Lua
  * newLISP
  * Perl
  * PHP
  * Python
  * [RSpec](https://atom.io/packages/language-rspec) <sup>‡</sup><sup>*</sup>
  * Ruby
  * Scala


You only have to add a few lines in a PR to support another.

### Limitations

<sup>^</sup> Running selections of code for CoffeeScript (Literate) only works when selecting just the code blocks

<sup>†</sup> Erlang uses `erl` for limited selection based runs (see [#70](https://github.com/rgbkrk/atom-script/pull/70))

<sup>‡</sup> This grammar requires a language package to be installed.

<sup>\*</sup> Go, F#, and RSpec only support file based runs

## Installation

`apm install script`

## Usage

Make sure to run `atom` from the command line to get full access to your environment variables. Running Atom from the icon will launch using launchctl's environment.

Select some code and hit `⌘-i` to run just that selection.

`⌘-i` to run your entire file.

`⌘-shift-i` to configure command options and program arguments

`ctrl-c` will kill the process but leaves the pane open.

`ctrl-w` closes the pane and kills the process.

To kill everything, click the close icon in the upper right and just go back to
coding.

## Development

Use the atom [contributing guidelines](https://atom.io/docs/latest/contributing).
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
