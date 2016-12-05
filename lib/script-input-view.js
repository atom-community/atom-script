'use babel';

import { Emitter, CompositeDisposable } from 'atom';
import { $$, View } from 'atom-space-pen-views';

export default class ScriptInputView extends View {
  static content() {
    return this.div({ class: 'script-input-view' }, () => {
      this.div({ class: 'caption' }, '');
      return this.tag('atom-text-editor', { mini: '', class: 'editor mini' });
    },
    );
  }

  initialize(options) {
    this.options = options;
    this.emitter = new Emitter();

    this.panel = atom.workspace.addModalPanel({ item: this });
    this.panel.hide();

    this.editor = this.find('atom-text-editor').get(0).getModel();

    // set default text
    if (this.options.default) {
      this.editor.setText(this.options.default);
      this.editor.selectAll();
    }

    // caption text
    if (this.options.caption) {
      this.find('.caption').text(this.options.caption);
    }

    this.find('atom-text-editor').on('keydown', (e) => {
      if (e.keyCode === 27) {
        e.stopPropagation();
        this.emitter.emit('on-cancel');
        return this.hide();
      }
    },
    );

    this.subscriptions = new CompositeDisposable();
    return this.subscriptions.add(atom.commands.add('atom-workspace', {
      'core:confirm': () => {
        this.emitter.emit('on-confirm', this.editor.getText().trim());
        return this.hide();
      },
    },
    ),
    );
  }

  onConfirm(callback) { return this.emitter.on('on-confirm', callback); }
  onCancel(callback) { return this.emitter.on('on-cancel', callback); }

  focus() {
    return this.find('atom-text-editor').focus();
  }

  show() {
    this.panel.show();
    return this.focus();
  }

  hide() {
    this.panel.hide();
    return this.destroy();
  }

  destroy() {
    __guard__(this.subscriptions, x => x.dispose());
    return this.panel.destroy();
  }
}

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}
