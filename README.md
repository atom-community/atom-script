# Run code in Atom!

![](https://f.cloud.github.com/assets/836375/2359256/844b39ba-a615-11e3-9732-d6a0cd5694a0.gif)

Currently supports:

  * Bash
  * Coffeescript
  * Go *
  * F# *
  * Haskell *
  * Javascript
  * newLISP
  * Perl
  * PHP
  * Python
  * Ruby

You only have to add a few lines in a PR to support another.

`*`'ed languages only support file based runs.

## Installation

`apm install script`

## Usage

Select some code and hit `⌘-i` to run just that selection.

`⌘-i` to run your entire file.

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
