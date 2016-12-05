'use babel';

import { CompositeDisposable, Emitter } from 'atom';
import { View } from 'atom-space-pen-views';
import ScriptInputView from './script-input-view';

export default class ScriptOptionsView extends View {

  static content() {
    return this.div({ class: 'options-view' }, () => {
      this.div({ class: 'panel-heading' }, 'Configure Run Options');
      this.table(() => {
        this.tr(() => {
          this.td({ class: 'first' }, () => this.label('Current Working Directory:'));
          return this.td({ class: 'second' }, () => this.tag('atom-text-editor', { mini: '', class: 'editor mini', outlet: 'inputCwd' }),
          );
        },
        );
        this.tr(() => {
          this.td(() => this.label('Command'));
          return this.td(() => this.tag('atom-text-editor', { mini: '', class: 'editor mini', outlet: 'inputCommand' }),
          );
        },
        );
        this.tr(() => {
          this.td(() => this.label('Command Arguments:'));
          return this.td(() => this.tag('atom-text-editor', { mini: '', class: 'editor mini', outlet: 'inputCommandArgs' }),
          );
        },
        );
        this.tr(() => {
          this.td(() => this.label('Program Arguments:'));
          return this.td(() => this.tag('atom-text-editor', { mini: '', class: 'editor mini', outlet: 'inputScriptArgs' }),
          );
        },
        );
        return this.tr(() => {
          this.td(() => this.label('Environment Variables:'));
          return this.td(() => this.tag('atom-text-editor', { mini: '', class: 'editor mini', outlet: 'inputEnv' }),
          );
        },
        );
      },
      );
      return this.div({ class: 'block buttons' }, () => {
        const css = 'btn inline-block-tight';
        this.button({ class: `btn ${css} cancel`, outlet: 'buttonCancel', click: 'close' }, () => this.span({ class: 'icon icon-x' }, 'Cancel'),
        );
        return this.span({ class: 'right-buttons' }, () => {
          this.button({ class: `btn ${css} save-profile`, outlet: 'buttonSaveProfile', click: 'saveProfile' }, () => this.span({ class: 'icon icon-file-text' }, 'Save as profile'),
          );
          return this.button({ class: `btn ${css} run`, outlet: 'buttonRun', click: 'run' }, () => this.span({ class: 'icon icon-playback-play' }, 'Run'),
          );
        },
        );
      },
      );
    },
    );
  }

  initialize(runOptions) {
    this.runOptions = runOptions;
    this.emitter = new Emitter();

    this.subscriptions = new CompositeDisposable();
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'core:cancel': () => this.hide(),
      'core:close': () => this.hide(),
      'script:close-options': () => this.hide(),
      'script:run-options': () => this.panel.isVisible() ? this.hide() : this.show(),
      'script:save-options': () => this.saveOptions(),
    },
    ),
    );

    // handling focus traversal and run on enter
    this.find('atom-text-editor').on('keydown', (e) => {
      if (e.keyCode !== 9 && e.keyCode !== 13) { return true; }

      switch (e.keyCode) {
        case 9:
          e.preventDefault();
          e.stopPropagation();
          const row = this.find(e.target).parents('tr:first').nextAll('tr:first');
          if (row.length) { return row.find('atom-text-editor').focus(); } else { return this.buttonCancel.focus(); }

        case 13: return this.run();
      }
    },
    );

    this.panel = atom.workspace.addModalPanel({ item: this });
    return this.panel.hide();
  }

  splitArgs(element) {
    let args = element.get(0).getModel().getText().trim();

    if (args.indexOf('"') === -1 && args.indexOf("'") === -1) {
      // no escaping, just split
      return (args.split(' ').filter(item => item !== '').map(item => item));
    }

    const replaces = {};

    const regexps = [/"[^"]*"/ig, /'[^']*'/ig];

    // find strings in arguments
    for (const regex of regexps) { var matches = ((matches != null) ? matches : []).concat((args.match(regex)) || []); }

    // format replacement as bash comment to avoid replacing valid input
    for (var match of matches) { (replaces[`\`#match${Object.keys(replaces).length + 1}\``] = match); }

    // replace strings
    for (match in replaces) { const part = replaces[match]; (args = args.replace(new RegExp(part, 'g'), match)); }
    const split = (args.split(' ').filter(item => item !== '').map(item => item));

    const replacer = function (argument) {
      for (match in replaces) { const replacement = replaces[match]; (argument = argument.replace(match, replacement)); }
      return argument;
    };

    // restore strings, strip quotes
    return (split.map(argument => replacer(argument).replace(/"|'/g, '')));
  }

  getOptions() {
    return {
      workingDirectory: this.inputCwd.get(0).getModel().getText(),
      cmd: this.inputCommand.get(0).getModel().getText(),
      cmdArgs: this.splitArgs(this.inputCommandArgs),
      env: this.inputEnv.get(0).getModel().getText(),
      scriptArgs: this.splitArgs(this.inputScriptArgs),
    };
  }

  saveOptions() {
    return (() => {
      const result = [];
      const object = this.getOptions();
      for (const key in object) {
        const value = object[key];
        result.push(this.runOptions[key] = value);
      }
      return result;
    })();
  }

  onProfileSave(callback) { return this.emitter.on('on-profile-save', callback); }

  // Saves specified options as new profile
  saveProfile() {
    this.hide();

    const options = this.getOptions();

    const inputView = new ScriptInputView({ caption: 'Enter profile name:' });
    inputView.onCancel(() => this.show(),
    );
    inputView.onConfirm((profileName) => {
      if (!profileName) { return; }
      for (const editor of this.find('atom-text-editor')) { editor.getModel().setText(''); }

      // clean up the options
      this.saveOptions();

      // add to global profiles list
      return this.emitter.emit('on-profile-save', { name: profileName, options });
    },
    );

    return inputView.show();
  }

  close() {
    return this.hide();
  }

  destroy() {
    return __guard__(this.subscriptions, x => x.dispose());
  }

  show() {
    this.panel.show();
    return this.inputCwd.focus();
  }

  hide() {
    this.panel.hide();
    return atom.workspace.getActivePane().activate();
  }

  run() {
    this.saveOptions();
    this.hide();
    return atom.commands.dispatch(this.workspaceView(), 'script:run');
  }

  workspaceView() {
    return atom.views.getView(atom.workspace);
  }
}

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}
