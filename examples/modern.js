import {exec} from 'child_process'

const timeout = s => new Promise(resolve => setTimeout(resolve, s * 1000)) // ms

const sleep = async(s, message) => {
  console.log("Awaiting Promise…") // This selected line should run.
  await timeout(s)
  return console.log(message)
}

sleep(1, "Done.")
