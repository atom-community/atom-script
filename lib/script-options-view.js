'use babel';

import { CompositeDisposable, Emitter } from 'atom';
import { View } from 'atom-space-pen-views';
import _ from 'underscore';
import ScriptInputView from './script-input-view';

export default class ScriptOptionsView extends View {

  static content() {
    this.div({ class: 'options-view' }, () => {
      this.h4({ class: 'modal-header' }, 'Configure Run Options');
      this.div({ class: 'modal-body' }, () => {
        this.table(() => {
          this.tr(() => {
            this.td({ class: 'first' }, () => this.label('Current Working Directory:'));
            this.td({ class: 'second' }, () => this.tag('atom-text-editor', { mini: '', class: 'editor mini', outlet: 'inputCwd' }));
          });
          this.tr(() => {
            this.td(() => this.label('Command'));
            this.td(() => this.tag('atom-text-editor', { mini: '', class: 'editor mini', outlet: 'inputCommand' }));
          });
          this.tr(() => {
            this.td(() => this.label('Command Arguments:'));
            this.td(() => this.tag('atom-text-editor', { mini: '', class: 'editor mini', outlet: 'inputCommandArgs' }));
          });
          this.tr(() => {
            this.td(() => this.label('Program Arguments:'));
            this.td(() => this.tag('atom-text-editor', { mini: '', class: 'editor mini', outlet: 'inputScriptArgs' }));
          });
          this.tr(() => {
            this.td(() => this.label('Environment Variables:'));
            this.td(() => this.tag('atom-text-editor', { mini: '', class: 'editor mini', outlet: 'inputEnv' }));
          });
        });
      });
      this.div({ class: 'modal-footer' }, () => {
        const css = 'btn inline-block-tight';
        this.button({ class: `btn ${css} cancel`, outlet: 'buttonCancel', click: 'close' }, () =>
          this.span({ class: 'icon icon-x' }, 'Cancel'),
        );
        this.span({ class: 'pull-right' }, () => {
          this.button({ class: `btn ${css} save-profile`, outlet: 'buttonSaveProfile', click: 'saveProfile' }, () =>
            this.span({ class: 'icon icon-file-text' }, 'Save as profile'),
          );
          this.button({ class: `btn ${css} run`, outlet: 'buttonRun', click: 'run' }, () =>
            this.span({ class: 'icon icon-playback-play' }, 'Run'),
          );
        });
      });
    });
  }

  initialize(runOptions) {
    this.runOptions = runOptions;
    this.emitter = new Emitter();

    this.subscriptions = new CompositeDisposable();
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'core:cancel': () => this.hide(),
      'core:close': () => this.hide(),
      'script:close-options': () => this.hide(),
      'script:run-options': () => (this.panel.isVisible() ? this.hide() : this.show()),
      'script:save-options': () => this.saveOptions(),
    }));

    // handling focus traversal and run on enter
    this.find('atom-text-editor').on('keydown', (e) => {
      if (e.keyCode !== 9 && e.keyCode !== 13) return true;

      switch (e.keyCode) {
        case 9: {
          e.preventDefault();
          e.stopPropagation();
          const row = this.find(e.target).parents('tr:first').nextAll('tr:first');
          if (row.length) {
            return row.find('atom-text-editor').focus();
          }
          return this.buttonCancel.focus();
        }
        case 13: return this.run();
      }
      return null;
    });

    this.panel = atom.workspace.addModalPanel({ item: this });
    this.panel.hide();
  }

  static splitArgs(argText) {
    const text = argText.trim();
    const argSubstringRegex = /([^'"\s]+)|((["'])(.*?)\3)/g;
    const args = [];
    let lastMatchEndPosition = -1;
    let match = argSubstringRegex.exec(text);
    while (match !== null) {
      const matchWithoutQuotes = match[1] || match[4];
      // Combine current result with last match, if last match ended where this
      // one begins.
      if (lastMatchEndPosition === match.index) {
        args[args.length - 1] += matchWithoutQuotes;
      } else {
        args.push(matchWithoutQuotes);
      }

      lastMatchEndPosition = argSubstringRegex.lastIndex;
      match = argSubstringRegex.exec(text);
    }
    return args;
  }

  getOptions() {
    return {
      workingDirectory: this.inputCwd.get(0).getModel().getText(),
      cmd: this.inputCommand.get(0).getModel().getText(),
      cmdArgs: this.constructor.splitArgs(
        this.inputCommandArgs.get(0).getModel().getText(),
      ),
      env: this.inputEnv.get(0).getModel().getText(),
      scriptArgs: this.constructor.splitArgs(
        this.inputScriptArgs.get(0).getModel().getText(),
      ),
    };
  }

  saveOptions() {
    const options = this.getOptions();
    for (const option in options) {
      const value = options[option];
      this.runOptions[option] = value;
    }
  }

  onProfileSave(callback) {
    return this.emitter.on('on-profile-save', callback);
  }

  // Saves specified options as new profile
  saveProfile() {
    this.hide();

    const options = this.getOptions();

    const inputView = new ScriptInputView({ caption: 'Enter profile name:' });
    inputView.onCancel(() => this.show());
    inputView.onConfirm((profileName) => {
      if (!profileName) return;
      _.forEach(this.find('atom-text-editor'), (editor) => {
        editor.getModel().setText('');
      });

      // clean up the options
      this.saveOptions();

      // add to global profiles list
      this.emitter.emit('on-profile-save', { name: profileName, options });
    });

    inputView.show();
  }

  close() {
    this.hide();
  }

  destroy() {
    if (this.subscriptions) this.subscriptions.dispose();
  }

  show() {
    this.panel.show();
    this.inputCwd.focus();
  }

  hide() {
    this.panel.hide();
    atom.workspace.getActivePane().activate();
  }

  run() {
    this.saveOptions();
    this.hide();
    atom.commands.dispatch(this.getWorkspaceView(), 'script:run');
  }

  getWorkspaceView() {
    return atom.views.getView(atom.workspace);
  }
}
