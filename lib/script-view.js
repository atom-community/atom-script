'use babel';
import { View, $$ } from 'atom-space-pen-views';

import HeaderView from './header-view';
import { MessagePanelView } from 'atom-message-panel';
import AnsiFilter from 'ansi-to-html';
import stripAnsi from 'strip-ansi';
import linkPaths from './link-paths';
import _ from 'underscore';

// Runs a portion of a script through an interpreter and displays it line by line
export default class ScriptView extends MessagePanelView {
  static initClass() {
  
    this.prototype.scrollTimeout = null;
  }
  constructor() {
    this.ansiFilter = new AnsiFilter;

    this.headerView = new HeaderView;

    super({title: this.headerView, rawTitle: true, closeMethod: 'destroy'});

    this.showInTab = this.showInTab.bind(this);
    this.setHeaderAndShowExecutionTime = this.setHeaderAndShowExecutionTime.bind(this);
    this.addClass('script-view');
    this.addShowInTabIcon();

    linkPaths.listen(this.body);
  }

  addShowInTabIcon() {
    let icon = $$(function() {
      return this.div({
        class: 'heading-show-in-tab inline-block icon-file-text',
        style: 'cursor: pointer;',
        outlet: 'btnShowInTab',
        title: 'Show output in new tab'
      });
    });

    icon.click(this.showInTab);
    return icon.insertBefore(this.btnAutoScroll);
  }

  showInTab() {
    // concat output
    let output = '';
    for (let message of this.messages) { output += message.text(); }

    // represent command context
    let context = '';
    if (this.commandContext) {
      context = `[Command: ${this.commandContext.getRepresentation()}]\n`;
    }

    // open new tab and set content to output
    return atom.workspace.open().then(editor => editor.setText(stripAnsi(context + output)));
  }

  setHeaderAndShowExecutionTime(returnCode, executionTime) {
    if (executionTime != null) {
      this.display('stdout', `[Finished in ${executionTime.toString()}s]`);
    } else {
      this.display('stdout');
    }

    if (returnCode === 0) {
      return this.setHeaderStatus('stop');
    } else {
      return this.setHeaderStatus('err');
    }
  }

  resetView(title = 'Loading...') {
    // Display window and load message

    // First run, create view
    if (!this.hasParent()) { this.attach(); }

    this.setHeaderTitle(title);
    this.setHeaderStatus('start');

    // Get script view ready
    return this.clear();
  }

  removePanel() {
    this.stop();
    this.detach();
    // the 'close' method from MessagePanelView actually destroys the panel
    return ScriptView.__super__.close.apply(this);
  }

  // This is triggered when hitting the 'close' button on the panel
  // We are not actually closing the panel here since we want to trigger
  // 'script:close-view' which will eventually remove the panel via 'removePanel'
  close() {
    let workspaceView = atom.views.getView(atom.workspace);
    return atom.commands.dispatch(workspaceView, 'script:close-view');
  }

  stop() {
    this.display('stdout', '^C');
    return this.setHeaderStatus('kill');
  }

  createGitHubIssueLink(argType, lang) {
    let title = `Add ${argType} support for ${lang}`;
    let body = `\
##### Platform: \`${process.platform}\`
---\
`;
    let encodedURI = encodeURI(`https://github.com/rgbkrk/atom-script/issues/new?title=${title}&body=${body}`);
    // NOTE: Replace "#" after regular encoding so we don't double escape it.
    encodedURI = encodedURI.replace(/#/g, '%23');

    let err = $$(function() {
      this.p({class: 'block'}, `${argType} runner not available for ${lang}.`);
      return this.p({class: 'block'}, () => {
        this.text('If it should exist, add an ');
        this.a({href: encodedURI}, 'issue on GitHub');
        return this.text(', or send your own pull request.');
      }
      );
    });
    return this.handleError(err);
  }

  showUnableToRunError(command) {
    return this.add($$(function() {
      this.h1('Unable to run');
      this.pre(_.escape(command));
      this.h2('Did you start Atom from the command line?');
      this.pre('  atom .');
      this.h2('Is it in your PATH?');
      return this.pre(`PATH: ${_.escape(process.env.PATH)}`);
    })
    );
  }

  showNoLanguageSpecified() {
    let err = $$(function() {
      return this.p(`You must select a language in the lower right, or save the file \
with an appropriate extension.`
      );
    });
    return this.handleError(err);
  }

  showLanguageNotSupported(lang) {
    let err = $$(function() {
      this.p({class: 'block'}, `Command not configured for ${lang}!`);
      return this.p({class: 'block'}, () => {
        this.text('Add an ');
        this.a({href: `https://github.com/rgbkrk/atom-script/issues/\
new?title=Add%20support%20for%20${lang}`
      }, 'issue on GitHub');
        return this.text(' or send your own Pull Request.');
      }
      );
    });
    return this.handleError(err);
  }

  handleError(err) {
    // Display error and kill process
    this.setHeaderTitle('Error');
    this.setHeaderStatus('err');
    this.add(err);
    return this.stop();
  }

  setHeaderStatus(status) {
    return this.headerView.setStatus(status);
  }

  setHeaderTitle(title) {
    return this.headerView.title.text(title);
  }

  display(css, line) {
    if (atom.config.get('script.escapeConsoleOutput')) {
      line = _.escape(line);
    }

    line = this.ansiFilter.toHtml(line);
    line = linkPaths(line);

    let {clientHeight, scrollTop, scrollHeight} = this.body[0];
    // indicates that the panel is scrolled to the bottom, thus we know that
    // we are not interfering with the user's manual scrolling
    let atEnd = scrollTop >= (scrollHeight - clientHeight);

    this.add($$(function() {
      return this.pre({class: `line ${css}`}, () => {
        return this.raw(line);
      }
      );
    })
    );

    if (atom.config.get('script.scrollWithOutput') && atEnd) {
      // Scroll down in a polling loop 'cause
      // we don't know when the reflow will finish.
      // See: http://stackoverflow.com/q/5017923/407845
      return this.checkScrollAgain(5)();
    }
  }
  checkScrollAgain(times) {
    return () => {
      this.body.scrollToBottom();

      clearTimeout(this.scrollTimeout);
      if (times > 1) {
        return this.scrollTimeout = setTimeout(this.checkScrollAgain(times - 1), 50);
      }
    };
  }

  copyResults() {
    if (this.results) {
      return atom.clipboard.write(stripAnsi(this.results));
    }
  }
};
ScriptView.initClass();
