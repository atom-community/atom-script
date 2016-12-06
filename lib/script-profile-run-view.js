'use babel';

/* eslint-disable func-names */
import { CompositeDisposable, Emitter } from 'atom';
import { $$, SelectListView } from 'atom-space-pen-views';
import ScriptInputView from './script-input-view';

export default class ScriptProfileRunView extends SelectListView {
  initialize(profiles) {
    this.profiles = profiles;
    super.initialize(...arguments);

    this.emitter = new Emitter();

    this.subscriptions = new CompositeDisposable();
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'core:cancel': () => this.hide(),
      'core:close': () => this.hide(),
      'script:run-with-profile': () => (this.panel.isVisible() ? this.hide() : this.show()),
    }));

    this.setItems(this.profiles);
    this.initializeView();
  }

  initializeView() {
    this.addClass('overlay from-top script-profile-run-view');
    // @panel.hide()

    this.buttons = $$(function () {
      this.div({ class: 'block buttons' }, () => {
        /* eslint-disable no-unused-vars */
        const css = 'btn inline-block-tight';
        /* eslint-enable no-unused-vars */
        this.button({ class: 'btn cancel' }, () => this.span({ class: 'icon icon-x' }, 'Cancel'));
        this.button({ class: 'btn rename' }, () => this.span({ class: 'icon icon-pencil' }, 'Rename'));
        this.button({ class: 'btn delete' }, () => this.span({ class: 'icon icon-trashcan' }, 'Delete'));
        this.button({ class: 'btn run' }, () => this.span({ class: 'icon icon-playback-play' }, 'Run'));
      });
    });

    // event handlers
    this.buttons.find('.btn.cancel').on('click', () => this.hide());
    this.buttons.find('.btn.rename').on('click', () => this.rename());
    this.buttons.find('.btn.delete').on('click', () => this.delete());
    this.buttons.find('.btn.run').on('click', () => this.run());

    // fix focus traversal (from run button to filter editor)
    this.buttons.find('.btn.run').on('keydown', (e) => {
      if (e.keyCode === 9) {
        e.stopPropagation();
        e.preventDefault();
        this.focusFilterEditor();
      }
    });

    // hide panel on ecsape
    this.on('keydown', (e) => {
      if (e.keyCode === 27) { this.hide(); }
      if (e.keyCode === 13) { this.run(); }
    });

    // append buttons container
    this.append(this.buttons);

    const selector = '.rename, .delete, .run';
    if (this.profiles.length) {
      this.buttons.find(selector).show();
    } else {
      this.buttons.find(selector).hide();
    }

    this.panel = atom.workspace.addModalPanel({ item: this });
    this.panel.hide();
  }

  onProfileDelete(callback) {
    return this.emitter.on('on-profile-delete', callback);
  }

  onProfileChange(callback) {
    return this.emitter.on('on-profile-change', callback);
  }

  onProfileRun(callback) {
    return this.emitter.on('on-profile-run', callback);
  }


  rename() {
    const profile = this.getSelectedItem();
    if (!profile) { return; }

    const inputView = new ScriptInputView({ caption: 'Enter new profile name:', default: profile.name });
    inputView.onCancel(() => this.show());
    inputView.onConfirm((newProfileName) => {
      if (!newProfileName) { return; }
      this.emitter.emit('on-profile-change', { profile, key: 'name', value: newProfileName });
    },
    );

    inputView.show();
  }

  delete() {
    const profile = this.getSelectedItem();
    if (!profile) { return; }

    atom.confirm({
      message: 'Delete profile',
      detailedMessage: `Are you sure you want to delete "${profile.name}" profile?`,
      buttons: {
        No: () => this.focusFilterEditor(),
        Yes: () => this.emitter.emit('on-profile-delete', profile),
      },
    });
  }

  getFilterKey() {
    return 'name';
  }

  getEmptyMessage() {
    return 'No profiles found';
  }

  viewForItem(item) {
    return $$(function () {
      this.li({ class: 'two-lines profile' }, () => {
        this.div({ class: 'primary-line name' }, () => this.text(item.name));
        this.div({ class: 'secondary-line description' }, () => this.text(item.description));
      });
    });
  }

  cancel() {}
  confirmed() {}

  show() {
    this.panel.show();
    this.focusFilterEditor();
  }

  hide() {
    this.panel.hide();
    atom.workspace.getActivePane().activate();
  }

  // Updates profiles
  setProfiles(profiles) {
    this.profiles = profiles;
    this.setItems(this.profiles);

    // toggle profile controls
    const selector = '.rename, .delete, .run';
    if (this.profiles.length) {
      this.buttons.find(selector).show();
    } else {
      this.buttons.find(selector).hide();
    }

    this.populateList();
    this.focusFilterEditor();
  }

  close() {}

  destroy() {
    if (this.subscriptions) this.subscriptions.dispose();
  }

  run() {
    const profile = this.getSelectedItem();
    if (!profile) { return; }

    this.emitter.emit('on-profile-run', profile);
    this.hide();
  }
}
