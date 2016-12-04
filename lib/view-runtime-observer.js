'use babel';
import { CompositeDisposable } from 'atom';

export default class ViewRuntimeObserver {
  constructor(view, subscriptions = new CompositeDisposable) {
    this.view = view;
    this.subscriptions = subscriptions;
  }

  observe(runtime) {
    this.subscriptions.add(runtime.onStart(() => {
      return this.view.resetView();
    }
    )
    );
    this.subscriptions.add(runtime.onStarted(ev => {
      return this.view.commandContext = ev;
    }
    )
    );
    this.subscriptions.add(runtime.onStopped(() => {
      return this.view.stop();
    }
    )
    );
    this.subscriptions.add(runtime.onDidWriteToStderr(ev => {
      return this.view.display('stderr', ev.message);
    }
    )
    );
    this.subscriptions.add(runtime.onDidWriteToStdout(ev => {
      return this.view.display('stdout', ev.message);
    }
    )
    );
    this.subscriptions.add(runtime.onDidExit(ev => {
      return this.view.setHeaderAndShowExecutionTime(ev.returnCode, ev.executionTime);
    }
    )
    );
    this.subscriptions.add(runtime.onDidNotRun(ev => {
      return this.view.showUnableToRunError(ev.command);
    }
    )
    );
    this.subscriptions.add(runtime.onDidContextCreate(ev => {
      let title = `${ev.lang} - ` + ev.filename + ((ev.lineNumber != null) ? `:${ev.lineNumber}` : '');
      return this.view.setHeaderTitle(title);
    }
    )
    );
    this.subscriptions.add(runtime.onDidNotSpecifyLanguage(() => {
      return this.view.showNoLanguageSpecified();
    }
    )
    );
    this.subscriptions.add(runtime.onDidNotSupportLanguage(ev => {
      return this.view.showLanguageNotSupported(ev.lang);
    }
    )
    );
    this.subscriptions.add(runtime.onDidNotSupportMode(ev => {
      return this.view.createGitHubIssueLink(ev.argType, ev.lang);
    }
    )
    );
    return this.subscriptions.add(runtime.onDidNotBuildArgs(ev => {
      return this.view.handleError(ev.error);
    }
    )
    );
  }

  destroy() {
    return __guard__(this.subscriptions, x => x.dispose());
  }
};

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}
