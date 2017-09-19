import {exec} from 'child_process'

timeout = (s) =>
  new Promise (resolve) =>
    setTimeout resolve, s * 1000 # ms

sleep = (s, message) =>
  console.log "Awaiting Promise…" # This selected line should run.
  await timeout s
  console.log message

sleep 1, "Done."
