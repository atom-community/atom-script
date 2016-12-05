'use babel';

import { View } from 'atom-space-pen-views';

export default class HeaderView extends View {

  static content() {
    return this.div({ class: 'header-view' }, () => {
      this.span({ class: 'heading-title', outlet: 'title' });
      return this.span({ class: 'heading-status', outlet: 'status' });
    });
  }

  setStatus(status) {
    this.status.removeClass('icon-alert icon-check icon-hourglass icon-stop');
    switch (status) {
      case 'start': return this.status.addClass('icon-hourglass');
      case 'stop': return this.status.addClass('icon-check');
      case 'kill': return this.status.addClass('icon-stop');
      case 'err': return this.status.addClass('icon-alert');
      default: return null;
    }
  }
}
