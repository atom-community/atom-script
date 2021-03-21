"use babel"

import { CompositeDisposable } from "atom"

import CodeContextBuilder from "./code-context-builder"
import GrammarUtils from "./grammar-utils"
import Runner from "./runner"
import Runtime from "./runtime"
import ScriptOptions from "./script-options"
import ScriptOptionsView from "./script-options-view"
import ScriptProfileRunView from "./script-profile-run-view"
import ScriptView from "./script-view"
import ViewRuntimeObserver from "./view-runtime-observer"

export const config = {
  enableExecTime: {
    title: "Output the time it took to execute the script",
    type: "boolean",
    default: true,
  },
  escapeConsoleOutput: {
    title: "HTML escape console output",
    type: "boolean",
    default: true,
  },
  ignoreSelection: {
    title: "Ignore selection (file-based runs only)",
    type: "boolean",
    default: false,
  },
  scrollWithOutput: {
    title: "Scroll with output",
    type: "boolean",
    default: true,
  },
  stopOnRerun: {
    title: "Stop running process on rerun",
    type: "boolean",
    default: false,
  },
  cwdBehavior: {
    title: "Default Current Working Directory (CWD) Behavior",
    description: "If no Run Options are set, this setting decides how to determine the CWD",
    type: "string",
    default: "First project directory",
    enum: ["First project directory", "Project directory of the script", "Directory of the script"],
  },
  position: {
    title: "Panel position",
    description: `Position of the panel with script output.
    (Changes to this value will be applied upon reopening the panel.)`,
    type: "string",
    default: "bottom",
    enum: ["top", "bottom", "left", "right"],
  },
}

// For some reason, the text of these options does not show in package settings view
// default: 'firstProj'
// enum: [
//   {value: 'firstProj', description: 'First project directory (if there is one)'}
//   {value: 'scriptProj', description: 'Project directory of the script (if there is one)'}
//   {value: 'scriptDir', description: 'Directory of the script'}
// ]
let scriptView = null
let scriptOptionsView = null
let scriptProfileRunView = null
let scriptOptions = null
let scriptProfiles = []
let runtime = null
const subscriptions = new CompositeDisposable()

export function activate(state) {
  scriptView = new ScriptView(state.scriptViewState)
  scriptOptions = new ScriptOptions()
  scriptOptionsView = new ScriptOptionsView(scriptOptions)

  // profiles loading
  scriptProfiles = []
  if (state.profiles) {
    for (const profile of state.profiles) {
      const so = ScriptOptions.createFromOptions(profile.name, profile)
      scriptProfiles.push(so)
    }
  }

  scriptProfileRunView = new ScriptProfileRunView(scriptProfiles)

  const codeContextBuilder = new CodeContextBuilder()
  const runner = new Runner(scriptOptions)

  const observer = new ViewRuntimeObserver(scriptView)

  runtime = new Runtime(runner, codeContextBuilder, [observer])

  subscriptions.add(
    atom.commands.add("atom-workspace", {
      "core:cancel": () => closeScriptViewAndStopRunner(),
      "core:close": () => closeScriptViewAndStopRunner(),
      "script:close-view": () => closeScriptViewAndStopRunner(),
      "script:copy-run-results": () => scriptView.copyResults(),
      "script:kill-process": () => runtime.stop(),
      "script:run-by-line-number": () => runtime.execute("Line Number Based"),
      "script:run": () => runtime.execute("Selection Based"),
    })
  )

  // profile created
  scriptOptionsView.onProfileSave((profileData) => {
    // create and fill out profile
    const profile = ScriptOptions.createFromOptions(profileData.name, profileData.options)

    const codeContext = runtime.codeContextBuilder.buildCodeContext(
      atom.workspace.getActiveTextEditor(),
      "Selection Based"
    )
    profile.lang = codeContext.lang

    // formatting description
    const opts = profile.toObject()
    let desc = `Language: ${codeContext.lang}`
    if (opts.cmd) {
      desc += `, Command: ${opts.cmd}`
    }
    if (opts.cmdArgs && opts.cmd) {
      desc += ` ${opts.cmdArgs.join(" ")}`
    }

    profile.description = desc
    scriptProfiles.push(profile)

    scriptOptionsView.hide()
    scriptProfileRunView.show()
    scriptProfileRunView.setProfiles(scriptProfiles)
  })

  // profile deleted
  scriptProfileRunView.onProfileDelete((profile) => {
    const index = scriptProfiles.indexOf(profile)
    if (index === -1) {
      return
    }

    if (index !== -1) {
      scriptProfiles.splice(index, 1)
    }
    scriptProfileRunView.setProfiles(scriptProfiles)
  })

  // profile renamed
  scriptProfileRunView.onProfileChange((data) => {
    const index = scriptProfiles.indexOf(data.profile)
    if (index === -1 || !scriptProfiles[index][data.key]) {
      return
    }

    scriptProfiles[index][data.key] = data.value
    scriptProfileRunView.show()
    scriptProfileRunView.setProfiles(scriptProfiles)
  })

  // profile renamed
  return scriptProfileRunView.onProfileRun((profile) => {
    if (!profile) {
      return
    }
    runtime.execute("Selection Based", null, profile)
  })
}

export function deactivate() {
  runtime.destroy()
  scriptView.removePanel()
  scriptOptionsView.close()
  scriptProfileRunView.close()
  subscriptions.dispose()
  GrammarUtils.deleteTempFiles()
}

export function closeScriptViewAndStopRunner() {
  runtime.stop()
  scriptView.removePanel()
}

// Public
//
// Service method that provides the default runtime that's configurable through Atom editor
// Use this service if you want to directly show the script's output in the Atom editor
//
// **Do not destroy this {Runtime} instance!** By doing so you'll break this plugin!
//
// Also note that the Script package isn't activated until you actually try to use it.
// That's why this service won't be automatically consumed. To be sure you consume it
// you may need to manually activate the package:
//
// atom.packages.loadPackage('script').activateNow() # this code doesn't include error handling!
//
// see https://github.com/s1mplex/Atom-Script-Runtime-Consumer-Sample for a full example
export function provideDefaultRuntime() {
  return runtime
}

// Public
//
// Service method that provides a blank runtime. You are free to configure any aspect of it:
// * Add observer (`runtime.addObserver(observer)`) - see {ViewRuntimeObserver} for an example
// * configure script options (`runtime.scriptOptions`)
//
// In contrast to `provideDefaultRuntime` you should dispose this {Runtime} when
// you no longer need it.
//
// Also note that the Script package isn't activated until you actually try to use it.
// That's why this service won't be automatically consumed. To be sure you consume it
// you may need to manually activate the package:
//
// atom.packages.loadPackage('script').activateNow() # this code doesn't include error handling!
//
// see https://github.com/s1mplex/Atom-Script-Runtime-Consumer-Sample for a full example
export function provideBlankRuntime() {
  const runner = new Runner(new ScriptOptions())
  const codeContextBuilder = new CodeContextBuilder()

  return new Runtime(runner, codeContextBuilder, [])
}

export function serialize() {
  // TODO: True serialization needs to take the options view into account
  //       and handle deserialization
  const serializedProfiles = []
  for (const profile of scriptProfiles) {
    serializedProfiles.push(profile.toObject())
  }

  return {
    scriptViewState: scriptView.serialize(),
    scriptOptionsViewState: scriptOptionsView.serialize(),
    profiles: serializedProfiles,
  }
}
