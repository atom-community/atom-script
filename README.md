# Run scripts in Atom!

![](https://f.cloud.github.com/assets/836375/2302319/b9ab8dec-a176-11e3-9073-a7d42c4fdf16.gif)

Currently supports:

  * Bash
  * Coffeescript
  * Go (only by file)
  * Javascript
  * Perl
  * PHP
  * Python
  * Ruby

You only have to add a few lines in a PR to support another.

## Installation

`apm install script`

## Usage

Select some code and hit `cmd-i`. Your code will get run in
a fresh instance of the interpreter used by your scripting language.

If you don't select any text, it will run the entire file instead.

`ctrl-c` will kill the process but leaves the pane open for viewing.

`ctrl-w` closes the pane and kills the process.

You can also close the pane and kill the process by clicking the close icon in the upper left.

## Development

Use the atom [contributing guidelines](https://atom.io/docs/v0.68.0/contributing).
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
Cut a branch while you're working and submit a Pull Request when done or when you want some feedback!
