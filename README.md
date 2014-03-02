# Run scripts in Atom!

![](https://f.cloud.github.com/assets/836375/2302319/b9ab8dec-a176-11e3-9073-a7d42c4fdf16.gif)

Currently supports:

  * Coffeescript
  * Javascript
  * Python
  * Ruby

You only have to add a few lines in a PR to support another.

## Installation

`apm install script`

## Usage

Select some code and hit `cmd-i`. Your code will get run in
a fresh instance of the interpreter used by your scripting language.

If you don't select any text, it will run the entire file by default.

## Development

Use the atom [contributing guidelines](https://atom.io/docs/v0.64.0/contributing),
a shortened form of which is below. Preferably, use

`apm develop script`

This will clone the `script` repository to `~/github` unless you set the
`ATOM_REPOS_HOME` environment variable.

If you cloned it somewhere else, you'll want to use `apm link --dev` within the
package directory, followed by `apm install` to get dependencies.

After pulling upstream changes, make sure to run `apm update`.

To start hacking, make sure to run `atom dev` from the package directory.
