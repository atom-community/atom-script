# Script runner for atom

Run snippets of scripts from within Atom.

:rotating_light: **Work in Progress** :rotating_light:

**NOTE**: This is currently hardcoded to work only with coffeescript. The next
issue to tackle is creating a mapping between languages, their interpreter, and
how to handle a chunk of code (does it need any other formatting)

To install simply run `apm install script`.

To use simply select some code and hit `cmd-i`. Your code will get run in
a fresh instance of the interpreter used by your scripting language.

![](https://f.cloud.github.com/assets/836375/2300807/e6d04a3c-a109-11e3-93e2-94d86965546d.gif)

## TODO

* Make mappings configurable
* Add tests
