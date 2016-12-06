'use babel';

import { CompositeDisposable } from 'atom';

import CodeContextBuilder from './code-context-builder';
import GrammarUtils from './grammar-utils';
import Runner from './runner';
import Runtime from './runtime';
import ScriptOptions from './script-options';
import ScriptOptionsView from './script-options-view';
import ScriptProfileRunView from './script-profile-run-view';
import ScriptView from './script-view';
import ViewRuntimeObserver from './view-runtime-observer';

export default {
  config: {
    enableExecTime: {
      title: 'Output the time it took to execute the script',
      type: 'boolean',
      default: true,
    },
    escapeConsoleOutput: {
      title: 'HTML escape console output',
      type: 'boolean',
      default: true,
    },
    ignoreSelection: {
      title: 'Ignore selection (file-based runs only)',
      type: 'boolean',
      default: false,
    },
    scrollWithOutput: {
      title: 'Scroll with output',
      type: 'boolean',
      default: true,
    },
    stopOnRerun: {
      title: 'Stop running process on rerun',
      type: 'boolean',
      default: false,
    },
    cwdBehavior: {
      title: 'Default CWD Behavior',
      description: 'If no Run Options are set, this setting decides how to determine the CWD',
      type: 'string',
      default: 'First project directory',
      enum: [
        'First project directory',
        'Project directory of the script',
        'Directory of the script',
      ],
    },
  },
  // For some reason, the text of these options does not show in package settings view
  // default: 'firstProj'
  // enum: [
  //   {value: 'firstProj', description: 'First project directory (if there is one)'}
  //   {value: 'scriptProj', description: 'Project directory of the script (if there is one)'}
  //   {value: 'scriptDir', description: 'Directory of the script'}
  // ]
  scriptView: null,
  scriptOptionsView: null,
  scriptProfileRunView: null,
  scriptOptions: null,
  scriptProfiles: [],

  activate(state) {
    this.scriptView = new ScriptView(state.scriptViewState);
    this.scriptOptions = new ScriptOptions();
    this.scriptOptionsView = new ScriptOptionsView(this.scriptOptions);

    // profiles loading
    this.scriptProfiles = [];
    if (state.profiles) {
      for (const profile of state.profiles) {
        const so = ScriptOptions.createFromOptions(profile.name, profile);
        this.scriptProfiles.push(so);
      }
    }

    this.scriptProfileRunView = new ScriptProfileRunView(this.scriptProfiles);

    const codeContextBuilder = new CodeContextBuilder();
    const runner = new Runner(this.scriptOptions);

    const observer = new ViewRuntimeObserver(this.scriptView);

    this.runtime = new Runtime(runner, codeContextBuilder, [observer]);

    this.subscriptions = new CompositeDisposable();
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'core:cancel': () => this.closeScriptViewAndStopRunner(),
      'core:close': () => this.closeScriptViewAndStopRunner(),
      'script:close-view': () => this.closeScriptViewAndStopRunner(),
      'script:copy-run-results': () => this.scriptView.copyResults(),
      'script:kill-process': () => this.runtime.stop(),
      'script:run-by-line-number': () => this.runtime.execute('Line Number Based'),
      'script:run': () => this.runtime.execute('Selection Based'),
    }));

    // profile created
    this.scriptOptionsView.onProfileSave((profileData) => {
      // create and fill out profile
      const profile = ScriptOptions.createFromOptions(profileData.name, profileData.options);

      const codeContext = this.runtime.codeContextBuilder.buildCodeContext(
        atom.workspace.getActiveTextEditor(), 'Selection Based');
      profile.lang = codeContext.lang;

      // formatting description
      const opts = profile.toObject();
      let desc = `Language: ${codeContext.lang}`;
      if (opts.cmd) { desc += `, Command: ${opts.cmd}`; }
      if (opts.cmdArgs && opts.cmd) { desc += ` ${opts.cmdArgs.join(' ')}`; }

      profile.description = desc;
      this.scriptProfiles.push(profile);

      this.scriptOptionsView.hide();
      this.scriptProfileRunView.show();
      this.scriptProfileRunView.setProfiles(this.scriptProfiles);
    });

    // profile deleted
    this.scriptProfileRunView.onProfileDelete((profile) => {
      const index = this.scriptProfiles.indexOf(profile);
      if (index === -1) { return; }

      if (index !== -1) { this.scriptProfiles.splice(index, 1); }
      this.scriptProfileRunView.setProfiles(this.scriptProfiles);
    });

    // profile renamed
    this.scriptProfileRunView.onProfileChange((data) => {
      const index = this.scriptProfiles.indexOf(data.profile);
      if (index === -1 || !this.scriptProfiles[index][data.key]) { return; }

      this.scriptProfiles[index][data.key] = data.value;
      this.scriptProfileRunView.show();
      this.scriptProfileRunView.setProfiles(this.scriptProfiles);
    });

    // profile renamed
    return this.scriptProfileRunView.onProfileRun((profile) => {
      if (!profile) { return; }
      this.runtime.execute('Selection Based', null, profile);
    });
  },

  deactivate() {
    this.runtime.destroy();
    this.scriptView.removePanel();
    this.scriptOptionsView.close();
    this.scriptProfileRunView.close();
    this.subscriptions.dispose();
    GrammarUtils.deleteTempFiles();
  },

  closeScriptViewAndStopRunner() {
    this.runtime.stop();
    this.scriptView.removePanel();
  },

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
  provideDefaultRuntime() {
    return this.runtime;
  },

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
  provideBlankRuntime() {
    const runner = new Runner(new ScriptOptions());
    const codeContextBuilder = new CodeContextBuilder();

    return new Runtime(runner, codeContextBuilder, []);
  },

  serialize() {
    // TODO: True serialization needs to take the options view into account
    //       and handle deserialization
    const serializedProfiles = [];
    for (const profile of this.scriptProfiles) { serializedProfiles.push(profile.toObject()); }

    return {
      scriptViewState: this.scriptView.serialize(),
      scriptOptionsViewState: this.scriptOptionsView.serialize(),
      profiles: serializedProfiles,
    };
  },
};
