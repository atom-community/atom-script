'use babel';

import { CompositeDisposable } from 'atom';

export default class ViewRuntimeObserver {
  constructor(view, subscriptions = new CompositeDisposable()) {
    this.view = view;
    this.subscriptions = subscriptions;
  }

  observe(runtime) {
    this.subscriptions.add(runtime.onStart(() => this.view.resetView()));
    this.subscriptions.add(runtime.onStarted((ev) => { this.view.commandContext = ev; }));
    this.subscriptions.add(runtime.onStopped(() => this.view.stop()));
    this.subscriptions.add(runtime.onDidWriteToStderr(ev => this.view.display('stderr', ev.message)));
    this.subscriptions.add(runtime.onDidWriteToStdout(ev => this.view.display('stdout', ev.message)));
    this.subscriptions.add(runtime.onDidExit(ev =>
      this.view.setHeaderAndShowExecutionTime(ev.returnCode, ev.executionTime)));
    this.subscriptions.add(runtime.onDidNotRun(ev => this.view.showUnableToRunError(ev.command)));
    this.subscriptions.add(runtime.onDidContextCreate((ev) => {
      const title = `${ev.lang} - ${ev.filename}${ev.lineNumber ? `:${ev.lineNumber}` : ''}`;
      this.view.setHeaderTitle(title);
    }));
    this.subscriptions.add(runtime.onDidNotSpecifyLanguage(() =>
      this.view.showNoLanguageSpecified()));
    this.subscriptions.add(runtime.onDidNotSupportLanguage(ev =>
      this.view.showLanguageNotSupported(ev.lang)));
    this.subscriptions.add(runtime.onDidNotSupportMode(ev =>
      this.view.createGitHubIssueLink(ev.argType, ev.lang)));
    this.subscriptions.add(runtime.onDidNotBuildArgs(ev => this.view.handleError(ev.error)));
  }

  destroy() {
    if (this.subscriptions) this.subscriptions.dispose();
  }
}
