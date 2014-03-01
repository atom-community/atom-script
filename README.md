# Script runner for atom

Run snippets of scripts from within Atom.

To install simply run `apm install script`.

To use simply select some code and hit `cmd-i`. Your code will get run in
a fresh instance of the interpreter used by your scripting language.

![](https://f.cloud.github.com/assets/836375/2300807/e6d04a3c-a109-11e3-93e2-94d86965546d.gif)

That's all completely a lie though, in that it's currently hardcoded to work
with coffeescript. Soon there will be a mapping between languages and how to run
their respective interpreters.

## TODO

* Make mappings configurable
* Add tests
