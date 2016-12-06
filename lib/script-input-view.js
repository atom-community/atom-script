'use babel';

import { Emitter, CompositeDisposable } from 'atom';
import { View } from 'atom-space-pen-views';

export default class ScriptInputView extends View {
  static content() {
    this.div({ class: 'script-input-view' }, () => {
      this.div({ class: 'caption' }, '');
      this.tag('atom-text-editor', { mini: '', class: 'editor mini' });
    });
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
        this.hide();
      }
    });

    this.subscriptions = new CompositeDisposable();
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'core:confirm': () => {
        this.emitter.emit('on-confirm', this.editor.getText().trim());
        this.hide();
      },
    }));
  }

  onConfirm(callback) {
    return this.emitter.on('on-confirm', callback);
  }

  onCancel(callback) {
    return this.emitter.on('on-cancel', callback);
  }

  focus() {
    this.find('atom-text-editor').focus();
  }

  show() {
    this.panel.show();
    this.focus();
  }

  hide() {
    this.panel.hide();
    this.destroy();
  }

  destroy() {
    if (this.subscriptions) this.subscriptions.dispose();
    this.panel.destroy();
  }
}
