[_Literate_] CoffeeScript
=========================
This is a [_literate_] CoffeeScript file, written in Markdown.

~~~ coffee

    import {exec} from 'child_process'

    timeout = (s) =>
      new Promise (resolve) =>
        setTimeout resolve, s * 1000 # ms

    sleep = (s, message) =>
      console.log "Awaiting Promise…" # This [whole] selected line should run.
      await timeout s
      console.log message

    sleep 1, "Done."
~~~

[_literate_]:   http://coffeescript.org/#literate
